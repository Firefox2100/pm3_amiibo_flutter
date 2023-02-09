import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'amiibo_info.dart';
import 'event_bus.dart';
import 'icon_grid.dart';
import 'selective_list.dart';
import 'setting.dart';
import 'functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Database? _database;

  final List<String> _characterList = [];
  final List<String> _seriesList = [];
  final List<String> _gameList = [];

  List<String>? _displayList;
  List<Map<String, dynamic>>? _displayMap;
  Map<String, dynamic>? _displayAmiibo;
  List<Map<String, dynamic>>? _displayUsage;

  bool _selectCharacter = true;
  bool _selectGames = false;
  bool _selectSeries = false;

  String? _selectedTitle;
  int? _selectedAmiibo;

  bool _isLoaded = false;

  Future<void> _fetchList() async {
    final appDocPath = await getApplicationDocumentsDirectory();

    _database =
        await openDatabase(join(appDocPath.path, "PM3-Amiibo/amiibo.db"));

    final List<Map<String, dynamic>> characterMap =
        await _database!.rawQuery('SELECT DISTINCT characters FROM amiibos');
    for (var item in characterMap) {
      _characterList.add(item["characters"]);
    }
    _characterList.sort();

    final List<Map<String, dynamic>> seriesMap =
        await _database!.rawQuery('SELECT DISTINCT game_series FROM amiibos');
    for (var item in seriesMap) {
      _seriesList.add(item["game_series"] ?? "Not in series");
    }
    _seriesList.sort();

    final List<Map<String, dynamic>> gamesMap =
        await _database!.rawQuery('SELECT DISTINCT game FROM usages');
    for (var item in gamesMap) {
      _gameList.add(item["game"]);
    }
    _gameList.sort();

    _displayList = List.from(_characterList);

    await _fetchGridAll();

    _selectedAmiibo = 0;
    await _fetchAmiibo();

    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("pm3_port")) {
      await pm3.init();
    }

    setState(() {
      _isLoaded = true;
    });
  }

  Future<void> _fetchGrid() async {
    final appDocPath = await getApplicationDocumentsDirectory();
    _database =
        await openDatabase(join(appDocPath.path, "PM3-Amiibo/amiibo.db"));

    String sql = "";

    if (_selectCharacter) {
      sql =
          'SELECT "id", "name", "head", "tail" FROM "amiibos" WHERE "characters" is "' +
              _selectedTitle! +
              '"';
    } else if (_selectSeries) {
      sql =
          'SELECT "id", "name", "head", "tail" FROM "amiibos" WHERE "game_series" is "' +
              _selectedTitle! +
              '"';
    } else if (_selectGames) {
      sql =
          'SELECT "id", "name", "head", "tail" FROM "amiibos" WHERE "name" in (SELECT "amiibo" FROM "usages" WHERE "game" is "' +
              _selectedTitle! +
              '")';
    }

    _displayMap = await _database!.rawQuery(sql);

    setState(() {
      _isLoaded = true;
    });
  }

  Future<void> _fetchGridAll() async {
    final appDocPath = await getApplicationDocumentsDirectory();
    _database =
        await openDatabase(join(appDocPath.path, "PM3-Amiibo/amiibo.db"));

    String sql = 'SELECT "id", "name", "head", "tail" FROM "amiibos"';

    _displayMap = await _database!.rawQuery(sql);
  }

  Future<void> _fetchAmiibo() async {
    final appDocPath = await getApplicationDocumentsDirectory();
    _database =
        await openDatabase(join(appDocPath.path, "PM3-Amiibo/amiibo.db"));

    String sql =
        'SELECT * FROM "amiibos" WHERE "id" is ' + _selectedAmiibo!.toString();

    var result = await _database!.rawQuery(sql);
    _displayAmiibo = result[0];

    sql = 'SELECT * FROM "usages" WHERE "amiibo" is "' +
        _displayAmiibo!["name"] +
        '"';

    _displayUsage = await _database!.rawQuery(sql);

    setState(() {
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final _onTitleSelection = eventBus.on<SelectTitleEvent>().listen((event) {
      _selectedTitle = event.title;
      _isLoaded = false;

      _fetchGrid();
    });

    final _onAmiiboSelection = eventBus.on<SelectAmiiboEvent>().listen((event) {
      _selectedAmiibo = event.index;
      _isLoaded = false;

      _fetchAmiibo();
    });

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        title: const Text("Proxmark3 Amiibo GUI"),
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          20.0,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    title: Text(
                      "Settings and Note",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Setting(),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.settings),
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                onTap: () => setState(() {
                  _selectCharacter = true;
                  _selectGames = false;
                  _selectSeries = false;

                  _displayList = List.from(_characterList);
                }),
                child: Text(
                  "Characters",
                  style: TextStyle(
                      color: _selectCharacter ? Colors.red : Colors.black),
                ),
              ),
              PopupMenuItem(
                onTap: () => setState(() {
                  _selectCharacter = false;
                  _selectGames = true;
                  _selectSeries = false;

                  _displayList = List.from(_gameList);
                }),
                child: Text(
                  "Games",
                  style: TextStyle(
                    color: _selectGames ? Colors.red : Colors.black,
                  ),
                ),
              ),
              PopupMenuItem(
                onTap: () => setState(() {
                  _selectCharacter = false;
                  _selectGames = false;
                  _selectSeries = true;

                  _displayList = List.from(_seriesList);
                }),
                child: Text(
                  "Game Series",
                  style: TextStyle(
                    color: _selectSeries ? Colors.red : Colors.black,
                  ),
                ),
              ),
            ],
          )
        ],
        elevation: 0,
      ),
      body: _isLoaded
          ? Row(
              children: [
                const SizedBox(width: 20),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: SelectiveList(contents: _displayList!),
                ),
                const SizedBox(width: 20),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width - 680),
                  child: IconGrid(contents: _displayMap!),
                ),
                const SizedBox(width: 20),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: AmiiboInfo(
                      contents: _displayAmiibo!, usage: _displayUsage!),
                ),
                const SizedBox(width: 20),
              ],
            )
          : Container(),
    );
  }
}
