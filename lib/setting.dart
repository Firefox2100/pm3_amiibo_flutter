import 'package:flutter/material.dart';
import 'package:pm3_amiibo_flutter/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => SettingState();
}

class SettingState extends State<Setting> {
  final TextEditingController _proxmarkPath = TextEditingController();
  final TextEditingController _proxmarkPort = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 40,
          ),
          child: Text(
            "Settings",
            style: TextStyle(
              fontSize: 23,
            ),
          ),
        ),
        Container(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text("Proxmark3 Directory"),
                ),
                TextField(
                  controller: _proxmarkPath,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Proxmark3 Path",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text("Proxmark3 Port"),
                ),
                TextField(
                  controller: _proxmarkPort,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Proxmark3 Port",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 40,
                  width: 50,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 40,
          width: 50,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('pm3_path', _proxmarkPath.text);
              await prefs.setString('pm3_port', _proxmarkPort.text);

              await pm3.init();
            },
            child: const Text(
              "Save",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        )
      ],
    );
  }
}
