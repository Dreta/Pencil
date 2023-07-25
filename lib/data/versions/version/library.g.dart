// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Library _$LibraryFromJson(Map<String, dynamic> json) => Library(
      LibraryDownloads.fromJson(json['downloads'] as Map<String, dynamic>),
      json['name'] as String,
      json['extract'] == null
          ? null
          : ExtractOptions.fromJson(json['extract'] as Map<String, dynamic>),
      (json['rules'] as List<dynamic>?)
          ?.map((e) => Rule.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['natives'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$LibraryToJson(Library instance) => <String, dynamic>{
      'downloads': instance.downloads,
      'name': instance.name,
      'extract': instance.extract,
      'rules': instance.rules,
      'natives': instance.natives,
    };

LibraryDownloads _$LibraryDownloadsFromJson(Map<String, dynamic> json) =>
    LibraryDownloads(
      json['artifact'] == null
          ? null
          : ArtifactDownload.fromJson(json['artifact'] as Map<String, dynamic>),
      (json['classifiers'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, ArtifactDownload.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$LibraryDownloadsToJson(LibraryDownloads instance) =>
    <String, dynamic>{
      'artifact': instance.artifact,
      'classifiers': instance.classifiers,
    };

ArtifactDownload _$ArtifactDownloadFromJson(Map<String, dynamic> json) =>
    ArtifactDownload(
      json['path'] as String,
      json['sha1'] as String?,
      json['size'] as int?,
      json['url'] as String,
    );

Map<String, dynamic> _$ArtifactDownloadToJson(ArtifactDownload instance) =>
    <String, dynamic>{
      'path': instance.path,
      'sha1': instance.sha1,
      'size': instance.size,
      'url': instance.url,
    };

ExtractOptions _$ExtractOptionsFromJson(Map<String, dynamic> json) =>
    ExtractOptions(
      (json['exclude'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ExtractOptionsToJson(ExtractOptions instance) =>
    <String, dynamic>{
      'exclude': instance.exclude,
    };
