import 'package:json_annotation/json_annotation.dart';
import 'package:pencil/data/modrinth/modrinth_project.dart';

part 'modrinth_search_result.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ModrinthSearchResult {
  ModrinthSearchResult(this.slug, this.title, this.description, this.categories, this.clientSide, this.serverSide,
      this.projectType, this.downloads, this.iconUrl, this.color, this.threadId, this.projectId, this.author,
      this.displayCategories, this.versions, this.follows, this.dateCreated, this.dateModified, this.latestVersion,
      this.license, this.gallery, this.featuredGallery, this.dependencies);

  final String slug;
  final String title;
  final String description;
  final List<String> categories;
  final ProjectSideSupport clientSide;
  final ProjectSideSupport serverSide;
  final ProjectType projectType;
  final int downloads;
  final String? iconUrl;
  final int? color;
  final String threadId;
  final String projectId;
  final String author;
  final List<String> displayCategories;
  final List<String> versions;
  final int follows;
  final DateTime dateCreated;
  final DateTime dateModified;
  final String latestVersion;
  final String license;
  final List<String> gallery;
  final String? featuredGallery;
  final List<String> dependencies;

  factory ModrinthSearchResult.fromJson(Map<String, dynamic> json) => _$ModrinthSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$ModrinthSearchResultToJson(this);
}
