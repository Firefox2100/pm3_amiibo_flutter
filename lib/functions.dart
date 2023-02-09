import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

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

    await Future.delayed(Duration(seconds: 3));
  }

  Future<void> writeBack(String path, String name) async{
    if (!initialized) {
      throw Exception("Instance is not initialized");
    }

    process!.stdin.writeln("hf mfu esave -f " + path);
    await Future.delayed(Duration(seconds: 3));

    final appDocDir = await getApplicationDocumentsDirectory();

    await File(path).rename(join(appDocDir.path, name));
  }

  Future<void> randomizeUID(String path) async {

  }
}

var pm3 = Proxmark3();
