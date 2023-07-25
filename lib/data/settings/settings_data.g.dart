// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsData _$SettingsDataFromJson(Map<String, dynamic> json) => SettingsData(
      json['launcher'] == null
          ? null
          : LauncherSettings.fromJson(json['launcher'] as Map<String, dynamic>),
      json['game'] == null
          ? null
          : GameSettings.fromJson(json['game'] as Map<String, dynamic>),
      json['java'] == null
          ? null
          : JavaSettings.fromJson(json['java'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SettingsDataToJson(SettingsData instance) =>
    <String, dynamic>{
      'launcher': instance.launcher,
      'game': instance.game,
      'java': instance.java,
    };

LauncherSettings _$LauncherSettingsFromJson(Map<String, dynamic> json) =>
    LauncherSettings(
      json['profilesDirectory'] as String?,
    )
      ..imagesDirectory = json['imagesDirectory'] as String?
      ..showReleases = json['showReleases'] as bool?
      ..showSnapshots = json['showSnapshots'] as bool?
      ..showHistorical = json['showHistorical'] as bool?
      ..checkUpdates = json['checkUpdates'] as bool?
      ..telemetry = json['telemetry'] as bool?
      ..host = json['host'] == null
          ? null
          : Host.fromJson(json['host'] as Map<String, dynamic>);

Map<String, dynamic> _$LauncherSettingsToJson(LauncherSettings instance) =>
    <String, dynamic>{
      'profilesDirectory': instance.profilesDirectory,
      'imagesDirectory': instance.imagesDirectory,
      'showReleases': instance.showReleases,
      'showSnapshots': instance.showSnapshots,
      'showHistorical': instance.showHistorical,
      'checkUpdates': instance.checkUpdates,
      'telemetry': instance.telemetry,
      'host': instance.host,
    };

GameSettings _$GameSettingsFromJson(Map<String, dynamic> json) => GameSettings()
  ..versionsDirectory = json['versionsDirectory'] as String?
  ..assetsDirectory = json['assetsDirectory'] as String?
  ..librariesDirectory = json['librariesDirectory'] as String?
  ..worldsDirectory = json['worldsDirectory'] as String?
  ..resourcePacksDirectory = json['resourcePacksDirectory'] as String?
  ..shaderPacksDirectory = json['shaderPacksDirectory'] as String?
  ..modsDirectory = json['modsDirectory'] as String?;

Map<String, dynamic> _$GameSettingsToJson(GameSettings instance) =>
    <String, dynamic>{
      'versionsDirectory': instance.versionsDirectory,
      'assetsDirectory': instance.assetsDirectory,
      'librariesDirectory': instance.librariesDirectory,
      'worldsDirectory': instance.worldsDirectory,
      'resourcePacksDirectory': instance.resourcePacksDirectory,
      'shaderPacksDirectory': instance.shaderPacksDirectory,
      'modsDirectory': instance.modsDirectory,
    };

JavaSettings _$JavaSettingsFromJson(Map<String, dynamic> json) => JavaSettings()
  ..useManaged = json['useManaged'] as bool?
  ..modernJavaHome = json['modernJavaHome'] as String?
  ..legacyJavaHome = json['legacyJavaHome'] as String?;

Map<String, dynamic> _$JavaSettingsToJson(JavaSettings instance) =>
    <String, dynamic>{
      'useManaged': instance.useManaged,
      'modernJavaHome': instance.modernJavaHome,
      'legacyJavaHome': instance.legacyJavaHome,
    };
