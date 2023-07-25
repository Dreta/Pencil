import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:pencil/data/settings/settings_data.dart';

class SettingsProvider extends ChangeNotifier {
  final File _settingsFile;
  late SettingsData data;

  SettingsProvider() : _settingsFile = File(getPlatformConfigPath()) {
    _settingsFile.createSync(recursive: true);
    String string = _settingsFile.readAsStringSync();
    data = SettingsData.fromJson(string.isEmpty ? {} : jsonDecode(string));
    data.setDefaults();
  }

  Future<void> save() async {
    notifyListeners();
    await _settingsFile.writeAsString(jsonEncode(data.toJson()));
  }

  static String getPlatformConfigPath() {
    if (Platform.isLinux) {
      return path.join(Platform.environment['XDG_CONFIG_HOME'] ?? path.join(Platform.environment['HOME']!, '.config'), 'pencil',
          'config.json');
    } else if (Platform.isWindows) {
      return path.join(Platform.environment['APPDATA']!, 'Pencil', 'config.json');
    } else if (Platform.isMacOS) {
      return path.join(Platform.environment['HOME']!, 'Library', 'Application Support', 'Pencil', 'config.json');
    }
    throw Exception('Unsupported Platform');
  }
}
