// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modrinth_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModrinthSearchResult _$ModrinthSearchResultFromJson(
        Map<String, dynamic> json) =>
    ModrinthSearchResult(
      json['slug'] as String,
      json['title'] as String,
      json['description'] as String,
      (json['categories'] as List<dynamic>).map((e) => e as String).toList(),
      $enumDecode(_$ProjectSideSupportEnumMap, json['client_side']),
      $enumDecode(_$ProjectSideSupportEnumMap, json['server_side']),
      $enumDecode(_$ProjectTypeEnumMap, json['project_type']),
      json['downloads'] as int,
      json['icon_url'] as String?,
      json['color'] as int?,
      json['thread_id'] as String,
      json['project_id'] as String,
      json['author'] as String,
      (json['display_categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      (json['versions'] as List<dynamic>).map((e) => e as String).toList(),
      json['follows'] as int,
      DateTime.parse(json['date_created'] as String),
      DateTime.parse(json['date_modified'] as String),
      json['latest_version'] as String,
      json['license'] as String,
      (json['gallery'] as List<dynamic>).map((e) => e as String).toList(),
      json['featured_gallery'] as String?,
      (json['dependencies'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ModrinthSearchResultToJson(
        ModrinthSearchResult instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'title': instance.title,
      'description': instance.description,
      'categories': instance.categories,
      'client_side': _$ProjectSideSupportEnumMap[instance.clientSide]!,
      'server_side': _$ProjectSideSupportEnumMap[instance.serverSide]!,
      'project_type': _$ProjectTypeEnumMap[instance.projectType]!,
      'downloads': instance.downloads,
      'icon_url': instance.iconUrl,
      'color': instance.color,
      'thread_id': instance.threadId,
      'project_id': instance.projectId,
      'author': instance.author,
      'display_categories': instance.displayCategories,
      'versions': instance.versions,
      'follows': instance.follows,
      'date_created': instance.dateCreated.toIso8601String(),
      'date_modified': instance.dateModified.toIso8601String(),
      'latest_version': instance.latestVersion,
      'license': instance.license,
      'gallery': instance.gallery,
      'featured_gallery': instance.featuredGallery,
      'dependencies': instance.dependencies,
    };

const _$ProjectSideSupportEnumMap = {
  ProjectSideSupport.required: 'required',
  ProjectSideSupport.optional: 'optional',
  ProjectSideSupport.unsupported: 'unsupported',
};

const _$ProjectTypeEnumMap = {
  ProjectType.mod: 'mod',
  ProjectType.modpack: 'modpack',
  ProjectType.resourcepack: 'resourcepack',
  ProjectType.shader: 'shader',
};
