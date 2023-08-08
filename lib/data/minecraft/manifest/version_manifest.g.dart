// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersionManifest _$VersionManifestFromJson(Map<String, dynamic> json) => VersionManifest(
      Latest.fromJson(json['latest'] as Map<String, dynamic>),
      (json['versions'] as List<dynamic>).map((e) => ManifestVersion.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$VersionManifestToJson(VersionManifest instance) => <String, dynamic>{
      'latest': instance.latest,
      'versions': instance.versions,
    };
