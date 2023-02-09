import 'dart:io';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, dynamic e) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              20.0,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        title: const Text(
          "Error",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(e.toString()),
        ),
      );
    },
  );
}

class Proxmark3 {
  String? port;
  Process? process;
  String? pm3Path;

  bool initialized = false;

  Future<bool> init() async{
    final prefs = await SharedPreferences.getInstance();
    pm3Path = prefs.getString('pm3_path');
    port = prefs.getString("pm3_port");

    if (process != null) {
      process!.stdin.writeln("exit");
      process!.kill();
    }

    String command = join(pm3Path!, "client", "proxmark3 ") + port!;
    process = await Process.start(command, []);

    initialized = true;
    return true;
  }

  Future<void> emulate(String path) async {
    if (!initialized) {
      throw Exception("Instance is not initialized");
    }

    process!.stdin.writeln("hf mfu eload -f " + path);
    process!.stdin.writeln("hf mfu sim -t 7");

    await Future.delayed(const Duration(seconds: 5));
  }

  Future<void> writeBack(String path) async{
    if (!initialized) {
      throw Exception("Instance is not initialized");
    }

    process!.stdin.writeln("hf mfu esave -f temp");
    await Future.delayed(const Duration(seconds: 5));

    await File(join(pm3Path!, "temp.bin")).rename(path);
  }

  Future<void> randomizeUID(String path) async {

  }
}

var pm3 = Proxmark3();
