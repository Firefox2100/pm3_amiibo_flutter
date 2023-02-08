import 'package:flutter/material.dart';
import '';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => SettingState();
}

class SettingState extends State<Setting> {
  TextEditingController _proxmarkPath = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
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
            padding: EdgeInsets.symmetric(horizontal: 15),
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
                SizedBox(
                  height: 40,
                  width: 50,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 40,
          width: 50,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
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
