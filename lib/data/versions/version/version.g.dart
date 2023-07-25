// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Version _$VersionFromJson(Map<String, dynamic> json) => Version(
      json['arguments'] == null
          ? null
          : Arguments.fromJson(json['arguments'] as Map<String, dynamic>),
      json['minecraftArguments'] as String?,
      AssetIndex.fromJson(json['assetIndex'] as Map<String, dynamic>),
      json['assets'] as String?,
      json['complianceLevel'] as int?,
      Downloads.fromJson(json['downloads'] as Map<String, dynamic>),
      json['id'] as String,
      json['inheritsFrom'] as String?,
      json['javaVersion'] == null
          ? null
          : JavaVersion.fromJson(json['javaVersion'] as Map<String, dynamic>),
      (json['libraries'] as List<dynamic>)
          .map((e) => Library.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['logging'] == null
          ? null
          : Logging.fromJson(json['logging'] as Map<String, dynamic>),
      json['mainClass'] as String,
      json['minimumLauncherVersion'] as int?,
      json['releaseTime'] == null
          ? null
          : DateTime.parse(json['releaseTime'] as String),
      json['time'] == null ? null : DateTime.parse(json['time'] as String),
      $enumDecode(_$VersionTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$VersionToJson(Version instance) => <String, dynamic>{
      'arguments': instance.arguments,
      'minecraftArguments': instance.minecraftArguments,
      'assetIndex': instance.assetIndex,
      'assets': instance.assets,
      'complianceLevel': instance.complianceLevel,
      'downloads': instance.downloads,
      'id': instance.id,
      'inheritsFrom': instance.inheritsFrom,
      'javaVersion': instance.javaVersion,
      'libraries': instance.libraries,
      'logging': instance.logging,
      'mainClass': instance.mainClass,
      'minimumLauncherVersion': instance.minimumLauncherVersion,
      'releaseTime': instance.releaseTime?.toIso8601String(),
      'time': instance.time?.toIso8601String(),
      'type': _$VersionTypeEnumMap[instance.type]!,
    };

const _$VersionTypeEnumMap = {
  VersionType.release: 'release',
  VersionType.snapshot: 'snapshot',
  VersionType.old_alpha: 'old_alpha',
  VersionType.old_beta: 'old_beta',
};
