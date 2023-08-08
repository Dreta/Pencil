import 'package:json_annotation/json_annotation.dart';

part 'modrinth_project.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ModrinthProject {
  ModrinthProject(
      this.slug,
      this.title,
      this.description,
      this.categories,
      this.clientSide,
      this.serverSide,
      this.body,
      this.status,
      this.requestedStatus,
      this.additionalCategories,
      this.issuesUrl,
      this.sourceUrl,
      this.wikiUrl,
      this.discordUrl,
      this.donationUrls,
      this.projectType,
      this.downloads,
      this.iconUrl,
      this.color,
      this.threadId,
      this.monetizationStatus,
      this.id,
      this.team,
      this.published,
      this.updated,
      this.approved,
      this.queued,
      this.followers,
      this.license,
      this.versions,
      this.gameVersions,
      this.loaders,
      this.gallery,
      this.featuredGallery,
      this.dependencies);

  final String slug;
  final String title;
  final String description;
  final List<String> categories;
  final ProjectSideSupport clientSide;
  final ProjectSideSupport serverSide;
  final String body;
  final ProjectStatus status;
  final ProjectStatus? requestedStatus;
  final List<String> additionalCategories;
  final String? issuesUrl;
  final String? sourceUrl;
  final String? wikiUrl;
  final String? discordUrl;
  final List<DonationPlatform> donationUrls;
  final ProjectType projectType;
  final int downloads;
  final String? iconUrl;
  final int? color;
  final String threadId;
  final String monetizationStatus;
  final String id;
  final String team;
  final DateTime published;
  final DateTime updated;
  final DateTime? approved;
  final DateTime? queued;
  final int followers;
  final ProjectLicense license;
  final List<String> versions;
  final List<String> gameVersions;
  final List<ProjectLoaders> loaders;
  final List<ProjectGalleryItem> gallery;
  final String? featuredGallery;
  final List<String> dependencies; // id-type, with type being required, optional, incompatible or embedded.

  factory ModrinthProject.fromJson(Map<String, dynamic> json) => _$ModrinthProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ModrinthProjectToJson(this);
}

@JsonSerializable()
class DonationPlatform {
  DonationPlatform(this.id, this.platform, this.url);

  final String id;
  final String platform;
  final String url;

  factory DonationPlatform.fromJson(Map<String, dynamic> json) => _$DonationPlatformFromJson(json);

  Map<String, dynamic> toJson() => _$DonationPlatformToJson(this);
}

@JsonSerializable()
class ProjectLicense {
  ProjectLicense(this.id, this.name, this.url);

  final String id;
  final String name;
  final String? url;

  factory ProjectLicense.fromJson(Map<String, dynamic> json) => _$ProjectLicenseFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectLicenseToJson(this);
}

@JsonSerializable()
class ProjectGalleryItem {
  ProjectGalleryItem(this.url, this.featured, this.title, this.description, this.created, this.ordering);

  final String url;
  final bool featured;
  final String? title;
  final String? description;
  final DateTime created;
  final int ordering;

  factory ProjectGalleryItem.fromJson(Map<String, dynamic> json) => _$ProjectGalleryItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectGalleryItemToJson(this);
}

enum ProjectSideSupport { required, optional, unsupported }

enum ProjectStatus { approved, archived, rejected, draft, unlisted, processing, withheld, scheduled, private, unknown }

enum ProjectType { mod, modpack, resourcepack, shader }

enum ProjectLoaders {
  forge,
  fabric,
  quilt,
  // unsupported
  liteloader,
  meddle,
  rift
}
