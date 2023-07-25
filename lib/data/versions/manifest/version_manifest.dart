import 'package:json_annotation/json_annotation.dart';
import 'package:pencil/data/versions/manifest/latest.dart';
import 'package:pencil/data/versions/manifest/manifest_version.dart';

part 'version_manifest.g.dart';

@JsonSerializable()
class VersionManifest {
  VersionManifest(this.latest, this.versions);

  Latest latest;
  List<ManifestVersion> versions;

  factory VersionManifest.fromJson(Map<String, dynamic> json) => _$VersionManifestFromJson(json);

  Map<String, dynamic> toJson() => _$VersionManifestToJson(this);
}
