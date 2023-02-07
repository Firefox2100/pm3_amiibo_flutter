import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AmiiboInfo extends StatefulWidget {
  const AmiiboInfo({super.key, required this.contents, required this.usage});

  final Map<String, dynamic> contents;
  final List<Map<String, dynamic>> usage;

  @override
  State<AmiiboInfo> createState() => AmiiboInfoState();
}

class AmiiboInfoState extends State<AmiiboInfo> {
  String? _dumpPath;

  Future<void> _getDumpPath() async {
    final data = widget.contents;

    final appDocPath = await getApplicationDocumentsDirectory();
    _dumpPath = join(appDocPath.path, "PM3-Amiibo",
        data["head"] + "-" + data["tail"] + ".bin");
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.contents;
    final usage = widget.usage;
    double height = MediaQuery.of(context).size.height;

    final imageName =
        'assets/icon_' + data['head'] + '-' + data['tail'] + '.png';

    String info = data["name"] + "\n";
    info += "Game Series: " + data["game_series"] + "\n";
    info += "Character: " + data["characters"] + "\n";
    info += "HEX ID: " + data["head"] + data["tail"] + "\n\n";
    info += "Usages:\n";

    for (var item in usage) {
      String temp = item["platform"] + " game " + item["game"] + ": " + item["usage"];
      temp += ". Write back: ";
      temp += item["write"] == 1 ? "True" : "False";
      temp += "\n";

      info += temp;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(imageName),
          height: 250,
          fit: BoxFit.fitWidth,
        ),
        SizedBox.fromSize(
          size: Size(50, 30),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: height - 550
          ),
          child: Expanded(
            child: SingleChildScrollView(
              child: Text(info),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: Size(50, 30),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrangeAccent,
            minimumSize: const Size(double.infinity, 40),
          ),
          onPressed: () {},
          child: const Text("Emulate"),
        ),
        SizedBox.fromSize(
          size: Size(50, 30),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrangeAccent,
            minimumSize: const Size(double.infinity, 40),
          ),
          onPressed: () {},
          child: const Text("Randomize UID"),
        ),
        SizedBox.fromSize(
          size: Size(50, 30),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrangeAccent,
            minimumSize: const Size(double.infinity, 40),
          ),
          onPressed: () {},
          child: const Text("Write back"),
        ),
      ],
    );
  }
}
