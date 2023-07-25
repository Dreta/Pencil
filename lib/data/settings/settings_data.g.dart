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
      json['imagesDirectory'] as String?,
      json['showReleases'] as bool?,
      json['showSnapshots'] as bool?,
      json['showHistorical'] as bool?,
      $enumDecodeNullable(_$ProfileSortTypeEnumMap, json['profileSort']),
      json['hideLauncherAfterStart'] as bool?,
      json['checkUpdates'] as bool?,
      json['telemetry'] as bool?,
      json['host'] == null
          ? null
          : Host.fromJson(json['host'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LauncherSettingsToJson(LauncherSettings instance) =>
    <String, dynamic>{
      'profilesDirectory': instance.profilesDirectory,
      'imagesDirectory': instance.imagesDirectory,
      'showReleases': instance.showReleases,
      'showSnapshots': instance.showSnapshots,
      'showHistorical': instance.showHistorical,
      'profileSort': _$ProfileSortTypeEnumMap[instance.profileSort],
      'hideLauncherAfterStart': instance.hideLauncherAfterStart,
      'checkUpdates': instance.checkUpdates,
      'telemetry': instance.telemetry,
      'host': instance.host,
    };

const _$ProfileSortTypeEnumMap = {
  ProfileSortType.lastPlayed: 'lastPlayed',
  ProfileSortType.name: 'name',
};

GameSettings _$GameSettingsFromJson(Map<String, dynamic> json) => GameSettings(
      json['versionsDirectory'] as String?,
      json['assetsDirectory'] as String?,
      json['librariesDirectory'] as String?,
      json['worldsDirectory'] as String?,
      json['resourcePacksDirectory'] as String?,
      json['shaderPacksDirectory'] as String?,
      json['modsDirectory'] as String?,
    );

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

JavaSettings _$JavaSettingsFromJson(Map<String, dynamic> json) => JavaSettings(
      json['useManaged'] as bool?,
      json['modernJavaHome'] as String?,
      json['legacyJavaHome'] as String?,
    );

Map<String, dynamic> _$JavaSettingsToJson(JavaSettings instance) =>
    <String, dynamic>{
      'useManaged': instance.useManaged,
      'modernJavaHome': instance.modernJavaHome,
      'legacyJavaHome': instance.legacyJavaHome,
    };
