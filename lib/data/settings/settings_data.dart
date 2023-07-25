import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart' as path;
import 'package:pencil/data/host.dart';

part 'settings_data.g.dart';

@JsonSerializable()
class SettingsData {
  SettingsData(this.launcher, this.game, this.java);

  LauncherSettings? launcher;
  GameSettings? game;
  JavaSettings? java;

  void setDefaults() {
    launcher ??= LauncherSettings.fromJson({});
    game ??= GameSettings.fromJson({});
    java ??= JavaSettings.fromJson({});
    launcher!.setDefaults();
    game!.setDefaults();
    java!.setDefaults();
  }

  factory SettingsData.fromJson(Map<String, dynamic> json) => _$SettingsDataFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsDataToJson(this);
}

enum ProfileSortType { lastPlayed, name }

@JsonSerializable()
class LauncherSettings {
  LauncherSettings(this.profilesDirectory, this.imagesDirectory, this.showReleases, this.showSnapshots, this.showHistorical,
      this.profileSort, this.checkUpdates, this.telemetry, this.host);

  String? profilesDirectory;
  String? imagesDirectory;
  bool? showReleases;
  bool? showSnapshots;
  bool? showHistorical;
  ProfileSortType? profileSort;
  bool? checkUpdates;
  bool? telemetry;
  Host? host;

  void setDefaults() {
    if (Platform.isLinux) {
      profilesDirectory ??= path.join(Platform.environment['HOME']!, '.local', 'share', 'Pencil', 'profiles');
      imagesDirectory ??= path.join(Platform.environment['HOME']!, '.local', 'share', 'Pencil', 'images');
    } else if (Platform.isWindows) {
      profilesDirectory ??= path.join(Platform.environment['APPDATA']!, 'Pencil', 'data', 'profiles');
      imagesDirectory ??= path.join(Platform.environment['APPDATA']!, 'Pencil', 'data', 'images');
    } else if (Platform.isMacOS) {
      profilesDirectory ??=
          path.join(Platform.environment['HOME']!, 'Library', 'Application Support', 'Pencil', 'data', 'profiles');
      imagesDirectory ??= path.join(Platform.environment['HOME']!, 'Library', 'Application Support', 'Pencil', 'data', 'images');
    } else {
      throw Exception('Unsupported Platform');
    }
    showReleases ??= true;
    showSnapshots ??= false;
    showHistorical ??= false;
    profileSort ??= ProfileSortType.lastPlayed;
    checkUpdates ??= true;
    telemetry ??= true;
    host ??= kHostPresetOfficial;
  }

  factory LauncherSettings.fromJson(Map<String, dynamic> json) => _$LauncherSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$LauncherSettingsToJson(this);
}

@JsonSerializable()
class GameSettings {
  GameSettings(this.versionsDirectory, this.assetsDirectory, this.librariesDirectory, this.worldsDirectory,
      this.resourcePacksDirectory, this.shaderPacksDirectory, this.modsDirectory);

  String? versionsDirectory;
  String? assetsDirectory;
  String? librariesDirectory;
  String? worldsDirectory;
  String? resourcePacksDirectory;
  String? shaderPacksDirectory;
  String? modsDirectory;

  void setDefaults() {
    if (Platform.isLinux) {
      versionsDirectory ??= path.join(Platform.environment['HOME']!, '.local', 'share', 'Pencil', 'versions');
      assetsDirectory ??= path.join(Platform.environment['HOME']!, '.local', 'share', 'Pencil', 'assets');
      librariesDirectory ??= path.join(Platform.environment['HOME']!, '.local', 'share', 'Pencil', 'libraries');
      modsDirectory ??= path.join(Platform.environment['HOME']!, '.local', 'share', 'Pencil', 'mods');
    } else if (Platform.isWindows) {
      versionsDirectory ??= path.join(Platform.environment['APPDATA']!, 'Pencil', 'data', 'games');
      assetsDirectory ??= path.join(Platform.environment['APPDATA']!, 'Pencil', 'data', 'assets');
      librariesDirectory ??= path.join(Platform.environment['APPDATA']!, 'Pencil', 'data', 'assets', 'libraries');
      modsDirectory ??= path.join(Platform.environment['HOME']!, '.local', 'share', 'Pencil', 'mods');
    } else if (Platform.isMacOS) {
      versionsDirectory ??=
          path.join(Platform.environment['HOME']!, 'Library', 'Application Support', 'Pencil', 'data', 'versions');
      assetsDirectory ??= path.join(Platform.environment['HOME']!, 'Library', 'Application Support', 'Pencil', 'data', 'assets');
      librariesDirectory ??=
          path.join(Platform.environment['HOME']!, 'Library', 'Application Support', 'Pencil', 'data', 'libraries');
      modsDirectory ??= path.join(Platform.environment['HOME']!, '.local', 'share', 'Pencil', 'mods');
    } else {
      throw Exception('Unsupported Platform');
    }
  }

  factory GameSettings.fromJson(Map<String, dynamic> json) => _$GameSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$GameSettingsToJson(this);
}

@JsonSerializable()
class JavaSettings {
  JavaSettings(this.useManaged, this.modernJavaHome, this.legacyJavaHome);

  bool? useManaged;
  String? modernJavaHome;
  String? legacyJavaHome;

  void setDefaults() {
    if (Platform.isLinux) {
      modernJavaHome ??= path.join(Platform.environment['HOME']!, '.local', 'share', 'Pencil', 'java', 'modern');
      legacyJavaHome ??= path.join(Platform.environment['HOME']!, '.local', 'share', 'Pencil', 'java', 'legacy');
    } else if (Platform.isWindows) {
      modernJavaHome ??= path.join(Platform.environment['APPDATA']!, 'Pencil', 'data', 'java', 'modern');
      legacyJavaHome ??= path.join(Platform.environment['APPDATA']!, 'Pencil', 'data', 'java', 'legacy');
    } else if (Platform.isMacOS) {
      modernJavaHome ??=
          path.join(Platform.environment['HOME']!, 'Library', 'Application Support', 'Pencil', 'data', 'java', 'modern');
      legacyJavaHome ??=
          path.join(Platform.environment['HOME']!, 'Library', 'Application Support', 'Pencil', 'data', 'java', 'legacy');
    } else {
      throw Exception('Unsupported Platform');
    }
    useManaged ??= true;
  }

  factory JavaSettings.fromJson(Map<String, dynamic> json) => _$JavaSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$JavaSettingsToJson(this);
}
