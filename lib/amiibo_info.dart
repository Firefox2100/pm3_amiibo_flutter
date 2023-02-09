import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
      String temp =
          item["platform"] + " game " + item["game"] + ": " + item["usage"];
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
          constraints: BoxConstraints(maxHeight: height - 550),
          child: Expanded(
            child: SingleChildScrollView(
              child: Text(info),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: Size(50, 15),
        ),
        SizedBox(
          height: 188,
          child: LoaderOverlay(
            useDefaultLoading: false,
            overlayWidget: Center(
              child: Image.asset(
                "assets/loading.gif",
                width: 250,
                height: 150,
              ),
            ),
            overlayOpacity: 0.6,
            overlayColor: Color(0xFFF1F1F1),
            overlayWholeScreen: false,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: Colors.blueGrey,
                ),
                color: Colors.white30,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    onPressed: () async {
                      context.loaderOverlay.show();
                      await Future.delayed(Duration(seconds: 2));
                      context.loaderOverlay.hide();
                    },
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
