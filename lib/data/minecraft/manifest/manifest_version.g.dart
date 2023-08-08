// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manifest_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManifestVersion _$ManifestVersionFromJson(Map<String, dynamic> json) =>
    ManifestVersion(
      json['id'] as String,
      $enumDecode(_$VersionTypeEnumMap, json['type']),
      json['url'] as String,
      DateTime.parse(json['time'] as String),
      DateTime.parse(json['releaseTime'] as String),
      json['sha1'] as String?,
      json['complianceLevel'] as int?,
    );

Map<String, dynamic> _$ManifestVersionToJson(ManifestVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$VersionTypeEnumMap[instance.type]!,
      'url': instance.url,
      'time': instance.time.toIso8601String(),
      'releaseTime': instance.releaseTime.toIso8601String(),
      'sha1': instance.sha1,
      'complianceLevel': instance.complianceLevel,
    };

const _$VersionTypeEnumMap = {
  VersionType.release: 'release',
  VersionType.snapshot: 'snapshot',
  VersionType.old_alpha: 'old_alpha',
  VersionType.old_beta: 'old_beta',
};
