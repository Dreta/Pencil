// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modrinth_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModrinthProject _$ModrinthProjectFromJson(Map<String, dynamic> json) =>
    ModrinthProject(
      json['slug'] as String,
      json['title'] as String,
      json['description'] as String,
      (json['categories'] as List<dynamic>).map((e) => e as String).toList(),
      $enumDecode(_$ProjectSideSupportEnumMap, json['client_side']),
      $enumDecode(_$ProjectSideSupportEnumMap, json['server_side']),
      json['body'] as String,
      $enumDecode(_$ProjectStatusEnumMap, json['status']),
      $enumDecodeNullable(_$ProjectStatusEnumMap, json['requested_status']),
      (json['additional_categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      json['issues_url'] as String?,
      json['source_url'] as String?,
      json['wiki_url'] as String?,
      json['discord_url'] as String?,
      (json['donation_urls'] as List<dynamic>)
          .map((e) => DonationPlatform.fromJson(e as Map<String, dynamic>))
          .toList(),
      $enumDecode(_$ProjectTypeEnumMap, json['project_type']),
      json['downloads'] as int,
      json['icon_url'] as String?,
      json['color'] as int?,
      json['thread_id'] as String,
      json['monetization_status'] as String,
      json['id'] as String,
      json['team'] as String,
      DateTime.parse(json['published'] as String),
      DateTime.parse(json['updated'] as String),
      json['approved'] == null
          ? null
          : DateTime.parse(json['approved'] as String),
      json['queued'] == null ? null : DateTime.parse(json['queued'] as String),
      json['followers'] as int,
      ProjectLicense.fromJson(json['license'] as Map<String, dynamic>),
      (json['versions'] as List<dynamic>).map((e) => e as String).toList(),
      (json['game_versions'] as List<dynamic>).map((e) => e as String).toList(),
      (json['loaders'] as List<dynamic>)
          .map((e) => $enumDecode(_$ProjectLoadersEnumMap, e))
          .toList(),
      (json['gallery'] as List<dynamic>)
          .map((e) => ProjectGalleryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['featured_gallery'] as String?,
      (json['dependencies'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ModrinthProjectToJson(ModrinthProject instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'title': instance.title,
      'description': instance.description,
      'categories': instance.categories,
      'client_side': _$ProjectSideSupportEnumMap[instance.clientSide]!,
      'server_side': _$ProjectSideSupportEnumMap[instance.serverSide]!,
      'body': instance.body,
      'status': _$ProjectStatusEnumMap[instance.status]!,
      'requested_status': _$ProjectStatusEnumMap[instance.requestedStatus],
      'additional_categories': instance.additionalCategories,
      'issues_url': instance.issuesUrl,
      'source_url': instance.sourceUrl,
      'wiki_url': instance.wikiUrl,
      'discord_url': instance.discordUrl,
      'donation_urls': instance.donationUrls,
      'project_type': _$ProjectTypeEnumMap[instance.projectType]!,
      'downloads': instance.downloads,
      'icon_url': instance.iconUrl,
      'color': instance.color,
      'thread_id': instance.threadId,
      'monetization_status': instance.monetizationStatus,
      'id': instance.id,
      'team': instance.team,
      'published': instance.published.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
      'approved': instance.approved?.toIso8601String(),
      'queued': instance.queued?.toIso8601String(),
      'followers': instance.followers,
      'license': instance.license,
      'versions': instance.versions,
      'game_versions': instance.gameVersions,
      'loaders':
          instance.loaders.map((e) => _$ProjectLoadersEnumMap[e]!).toList(),
      'gallery': instance.gallery,
      'featured_gallery': instance.featuredGallery,
      'dependencies': instance.dependencies,
    };

const _$ProjectSideSupportEnumMap = {
  ProjectSideSupport.required: 'required',
  ProjectSideSupport.optional: 'optional',
  ProjectSideSupport.unsupported: 'unsupported',
};

const _$ProjectStatusEnumMap = {
  ProjectStatus.approved: 'approved',
  ProjectStatus.archived: 'archived',
  ProjectStatus.rejected: 'rejected',
  ProjectStatus.draft: 'draft',
  ProjectStatus.unlisted: 'unlisted',
  ProjectStatus.processing: 'processing',
  ProjectStatus.withheld: 'withheld',
  ProjectStatus.scheduled: 'scheduled',
  ProjectStatus.private: 'private',
  ProjectStatus.unknown: 'unknown',
};

const _$ProjectTypeEnumMap = {
  ProjectType.mod: 'mod',
  ProjectType.modpack: 'modpack',
  ProjectType.resourcepack: 'resourcepack',
  ProjectType.shader: 'shader',
};

const _$ProjectLoadersEnumMap = {
  ProjectLoaders.forge: 'forge',
  ProjectLoaders.fabric: 'fabric',
  ProjectLoaders.quilt: 'quilt',
  ProjectLoaders.liteloader: 'liteloader',
  ProjectLoaders.meddle: 'meddle',
  ProjectLoaders.rift: 'rift',
};

DonationPlatform _$DonationPlatformFromJson(Map<String, dynamic> json) =>
    DonationPlatform(
      json['id'] as String,
      json['platform'] as String,
      json['url'] as String,
    );

Map<String, dynamic> _$DonationPlatformToJson(DonationPlatform instance) =>
    <String, dynamic>{
      'id': instance.id,
      'platform': instance.platform,
      'url': instance.url,
    };

ProjectLicense _$ProjectLicenseFromJson(Map<String, dynamic> json) =>
    ProjectLicense(
      json['id'] as String,
      json['name'] as String,
      json['url'] as String?,
    );

Map<String, dynamic> _$ProjectLicenseToJson(ProjectLicense instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
    };

ProjectGalleryItem _$ProjectGalleryItemFromJson(Map<String, dynamic> json) =>
    ProjectGalleryItem(
      json['url'] as String,
      json['featured'] as bool,
      json['title'] as String?,
      json['description'] as String?,
      DateTime.parse(json['created'] as String),
      json['ordering'] as int,
    );

Map<String, dynamic> _$ProjectGalleryItemToJson(ProjectGalleryItem instance) =>
    <String, dynamic>{
      'url': instance.url,
      'featured': instance.featured,
      'title': instance.title,
      'description': instance.description,
      'created': instance.created.toIso8601String(),
      'ordering': instance.ordering,
    };
