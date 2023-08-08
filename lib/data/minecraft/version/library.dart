import 'package:json_annotation/json_annotation.dart';
import 'package:pencil/data/minecraft/rule.dart';

part 'library.g.dart';

@JsonSerializable()
class Library {
  Library(this.downloads, this.name, this.extract, this.rules, this.natives);

  final LibraryDownloads downloads;
  final String name;
  final ExtractOptions? extract;
  List<Rule>? rules;
  Map<String, String>? natives; // os: name

  factory Library.fromJson(Map<String, dynamic> json) => _$LibraryFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryToJson(this);
}

@JsonSerializable()
class LibraryDownloads {
  LibraryDownloads(this.artifact, this.classifiers);

  ArtifactDownload? artifact;
  Map<String, ArtifactDownload>? classifiers; // maps to Library.natives, replace ${arch} with 32, 64 or arm

  factory LibraryDownloads.fromJson(Map<String, dynamic> json) => _$LibraryDownloadsFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryDownloadsToJson(this);
}

@JsonSerializable()
class ArtifactDownload {
  ArtifactDownload(this.path, this.sha1, this.size, this.url);

  final String path;
  String? sha1;
  int? size;
  final String url;

  factory ArtifactDownload.fromJson(Map<String, dynamic> json) => _$ArtifactDownloadFromJson(json);

  Map<String, dynamic> toJson() => _$ArtifactDownloadToJson(this);
}

@JsonSerializable()
class ExtractOptions {
  ExtractOptions(this.exclude);

  List<String>? exclude;

  factory ExtractOptions.fromJson(Map<String, dynamic> json) => _$ExtractOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$ExtractOptionsToJson(this);
}
