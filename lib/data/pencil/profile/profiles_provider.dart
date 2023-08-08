import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:pencil/data/pencil/profile/profile.dart';

class ProfilesProvider extends ChangeNotifier {
  final File _profilesFile;
  late Profiles profiles;
  bool isRunning = false;

  ProfilesProvider() : _profilesFile = File(getPlatformProfilesPath()) {
    _profilesFile.createSync(recursive: true);
    String string = _profilesFile.readAsStringSync();
    profiles = Profiles.fromJson(string.isEmpty ? {} : jsonDecode(string));
  }

  void notify() {
    notifyListeners();
  }

  Future<void> addProfile(Profile profile) async {
    profiles.profiles[profile.uuid] = profile;
    profiles.selectedProfile = profile.uuid;
    await save();
  }

  Future<void> removeProfile(String uuid) async {
    profiles.profiles.remove(uuid);
    if (profiles.selectedProfile == uuid) {
      if (profiles.profiles.isEmpty) {
        profiles.selectedProfile = null;
      } else {
        profiles.selectedProfile = profiles.profiles.entries.first.key;
      }
    }
    await save();
  }

  Future<void> save() async {
    if (profiles.profiles.isNotEmpty) {
      profiles.selectedProfile ??= profiles.profiles.entries.first.key;
    }
    notifyListeners();
    await _profilesFile.writeAsString(jsonEncode(profiles.toJson()));
  }

  static String getPlatformProfilesPath() {
    if (Platform.isLinux) {
      return path.join(Platform.environment['XDG_CONFIG_HOME'] ?? path.join(Platform.environment['HOME']!, '.config'), 'pencil',
          'profiles.json');
    } else if (Platform.isWindows) {
      return path.join(Platform.environment['APPDATA']!, 'Pencil', 'profiles.json');
    } else if (Platform.isMacOS) {
      return path.join(Platform.environment['HOME']!, 'Library', 'Application Support', 'Pencil', 'profiles.json');
    }
    throw Exception('Unsupported Platform');
  }
}
