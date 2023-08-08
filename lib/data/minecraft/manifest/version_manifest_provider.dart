import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:pencil/constants.dart';
import 'package:pencil/data/pencil/settings/settings_provider.dart';
import 'package:pencil/data/pencil/task/task.dart';
import 'package:pencil/data/pencil/task/tasks_provider.dart';
import 'package:pencil/data/minecraft/manifest/version_manifest.dart';
import 'package:provider/provider.dart';

class VersionManifestProvider extends ChangeNotifier {
  late File _manifestFile;
  VersionManifest? manifest;

  Future<void> init(BuildContext context) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    TasksProvider tasks = Provider.of<TasksProvider>(context, listen: false);
    _manifestFile = File(path.join(settings.data.game!.versionsDirectory!, 'version_manifest_v2.json'));
    if (!(await _manifestFile.exists())) {
      await _manifestFile.create(recursive: true);
    }
    Task task = Task(name: 'Downloading version manifest', type: TaskType.gameDownload);
    tasks.addTask(task);
    await download(context);
    tasks.removeTask(task);
  }

  Future<void> download(BuildContext context) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    try {
      http.Response r = await http.get(
          Uri.parse(settings.data.launcher!.host!.formatLink('https://piston-meta.mojang.com/mc/game/version_manifest_v2.json')),
          headers: {'User-Agent': kUserAgent});
      manifest = VersionManifest.fromJson(jsonDecode(utf8.decode(r.bodyBytes)));
    } catch (e) {
      try {
        manifest = VersionManifest.fromJson(jsonDecode(await _manifestFile.readAsString()));
      } catch (e2) {
        if (context.mounted) {
          showDialog(
              context: kBaseNavigatorKey.currentContext!,
              builder: (context) => AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                      title: const Text('Failed to download version manifest'),
                      content: const Text(
                          'You won\'t be able to download the game or create profiles. Please check your internet connection.'),
                      actions: [
                        TextButton(
                            child: const Text('Confirm'),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ]));
        }
      }
    }
    if (manifest != null) {
      await _manifestFile.writeAsString(jsonEncode(manifest!.toJson()));
    }
  }
}
