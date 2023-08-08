import 'package:json_annotation/json_annotation.dart';
import 'package:pencil/data/modrinth/modrinth_project.dart';

part 'modrinth_version.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ModrinthVersion {
  ModrinthVersion(
      this.name,
      this.versionNumber,
      this.changelog,
      this.dependencies,
      this.gameVersions,
      this.versionType,
      this.loaders,
      this.featured,
      this.status,
      this.requestedStatus,
      this.id,
      this.projectId,
      this.authorId,
      this.datePublished,
      this.downloads);

  final String name;
  final String versionNumber;
  final String? changelog;
  final List<VersionDependency> dependencies;
  final List<String> gameVersions;
  final VersionType versionType;
  final List<ProjectLoaders> loaders;
  final bool featured;
  final VersionStatus status;
  final VersionStatus? requestedStatus;
  final String id;
  final String projectId;
  final String authorId;
  final DateTime datePublished;
  final int downloads;

  factory ModrinthVersion.fromJson(Map<String, dynamic> json) => _$ModrinthVersionFromJson(json);

  Map<String, dynamic> toJson() => _$ModrinthVersionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class VersionDependency {
  VersionDependency(this.versionId, this.projectId, this.fileName, this.dependencyType);

  final String versionId;
  final String projectId;
  final String fileName;
  final DependencyType dependencyType;

  factory VersionDependency.fromJson(Map<String, dynamic> json) => _$VersionDependencyFromJson(json);

  Map<String, dynamic> toJson() => _$VersionDependencyToJson(this);
}

@JsonSerializable()
class VersionFile {
  VersionFile(this.hashes, this.url, this.filename, this.primary, this.size);

  final Hash hashes;
  final String url;
  final String filename;
  final bool primary;
  final int size;

  factory VersionFile.fromJson(Map<String, dynamic> json) => _$VersionFileFromJson(json);

  Map<String, dynamic> toJson() => _$VersionFileToJson(this);
}

@JsonSerializable()
class Hash {
  Hash(this.sha512, this.sha1);

  final String sha512;
  final String sha1;

  factory Hash.fromJson(Map<String, dynamic> json) => _$HashFromJson(json);

  Map<String, dynamic> toJson() => _$HashToJson(this);
}

enum DependencyType { required, optional, incompatible, embedded }

enum VersionType { release, beta, alpha }

enum VersionStatus { listed, archived, draft, unlisted, scheduled, unknown }
