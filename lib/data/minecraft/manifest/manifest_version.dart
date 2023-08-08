import 'package:json_annotation/json_annotation.dart';
import 'package:pencil/data/minecraft/version_type.dart';

part 'manifest_version.g.dart';

@JsonSerializable()
class ManifestVersion {
  ManifestVersion(this.id, this.type, this.url, this.time, this.releaseTime, this.sha1, this.complianceLevel);

  final String id;
  final VersionType type;
  final String url;
  final DateTime time;
  final DateTime releaseTime;
  final String? sha1;
  final int? complianceLevel;

  factory ManifestVersion.fromJson(Map<String, dynamic> json) => _$ManifestVersionFromJson(json);

  Map<String, dynamic> toJson() => _$ManifestVersionToJson(this);
}
