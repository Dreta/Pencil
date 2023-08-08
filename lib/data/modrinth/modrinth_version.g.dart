// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modrinth_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModrinthVersion _$ModrinthVersionFromJson(Map<String, dynamic> json) =>
    ModrinthVersion(
      json['name'] as String,
      json['version_number'] as String,
      json['changelog'] as String?,
      (json['dependencies'] as List<dynamic>)
          .map((e) => VersionDependency.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['game_versions'] as List<dynamic>).map((e) => e as String).toList(),
      $enumDecode(_$VersionTypeEnumMap, json['version_type']),
      (json['loaders'] as List<dynamic>)
          .map((e) => $enumDecode(_$ProjectLoadersEnumMap, e))
          .toList(),
      json['featured'] as bool,
      $enumDecode(_$VersionStatusEnumMap, json['status']),
      $enumDecodeNullable(_$VersionStatusEnumMap, json['requested_status']),
      json['id'] as String,
      json['project_id'] as String,
      json['author_id'] as String,
      DateTime.parse(json['date_published'] as String),
      json['downloads'] as int,
    );

Map<String, dynamic> _$ModrinthVersionToJson(ModrinthVersion instance) =>
    <String, dynamic>{
      'name': instance.name,
      'version_number': instance.versionNumber,
      'changelog': instance.changelog,
      'dependencies': instance.dependencies,
      'game_versions': instance.gameVersions,
      'version_type': _$VersionTypeEnumMap[instance.versionType]!,
      'loaders':
          instance.loaders.map((e) => _$ProjectLoadersEnumMap[e]!).toList(),
      'featured': instance.featured,
      'status': _$VersionStatusEnumMap[instance.status]!,
      'requested_status': _$VersionStatusEnumMap[instance.requestedStatus],
      'id': instance.id,
      'project_id': instance.projectId,
      'author_id': instance.authorId,
      'date_published': instance.datePublished.toIso8601String(),
      'downloads': instance.downloads,
    };

const _$VersionTypeEnumMap = {
  VersionType.release: 'release',
  VersionType.beta: 'beta',
  VersionType.alpha: 'alpha',
};

const _$ProjectLoadersEnumMap = {
  ProjectLoaders.forge: 'forge',
  ProjectLoaders.fabric: 'fabric',
  ProjectLoaders.quilt: 'quilt',
  ProjectLoaders.liteloader: 'liteloader',
  ProjectLoaders.meddle: 'meddle',
  ProjectLoaders.rift: 'rift',
};

const _$VersionStatusEnumMap = {
  VersionStatus.listed: 'listed',
  VersionStatus.archived: 'archived',
  VersionStatus.draft: 'draft',
  VersionStatus.unlisted: 'unlisted',
  VersionStatus.scheduled: 'scheduled',
  VersionStatus.unknown: 'unknown',
};

VersionDependency _$VersionDependencyFromJson(Map<String, dynamic> json) =>
    VersionDependency(
      json['version_id'] as String,
      json['project_id'] as String,
      json['file_name'] as String,
      $enumDecode(_$DependencyTypeEnumMap, json['dependency_type']),
    );

Map<String, dynamic> _$VersionDependencyToJson(VersionDependency instance) =>
    <String, dynamic>{
      'version_id': instance.versionId,
      'project_id': instance.projectId,
      'file_name': instance.fileName,
      'dependency_type': _$DependencyTypeEnumMap[instance.dependencyType]!,
    };

const _$DependencyTypeEnumMap = {
  DependencyType.required: 'required',
  DependencyType.optional: 'optional',
  DependencyType.incompatible: 'incompatible',
  DependencyType.embedded: 'embedded',
};

VersionFile _$VersionFileFromJson(Map<String, dynamic> json) => VersionFile(
      Hash.fromJson(json['hashes'] as Map<String, dynamic>),
      json['url'] as String,
      json['filename'] as String,
      json['primary'] as bool,
      json['size'] as int,
    );

Map<String, dynamic> _$VersionFileToJson(VersionFile instance) =>
    <String, dynamic>{
      'hashes': instance.hashes,
      'url': instance.url,
      'filename': instance.filename,
      'primary': instance.primary,
      'size': instance.size,
    };

Hash _$HashFromJson(Map<String, dynamic> json) => Hash(
      json['sha512'] as String,
      json['sha1'] as String,
    );

Map<String, dynamic> _$HashToJson(Hash instance) => <String, dynamic>{
      'sha512': instance.sha512,
      'sha1': instance.sha1,
    };
