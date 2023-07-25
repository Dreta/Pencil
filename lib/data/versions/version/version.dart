import 'package:json_annotation/json_annotation.dart';
import 'package:pencil/data/versions/version/arguments.dart';
import 'package:pencil/data/versions/version/asset_index.dart';
import 'package:pencil/data/versions/version/downloads.dart';
import 'package:pencil/data/versions/version/java_version.dart';
import 'package:pencil/data/versions/version/library.dart';
import 'package:pencil/data/versions/version/logging.dart';
import 'package:pencil/data/versions/version_type.dart';

part 'version.g.dart';

@JsonSerializable()
class Version {
  Version(
      this.arguments,
      this.minecraftArguments,
      this.assetIndex,
      this.assets,
      this.complianceLevel,
      this.downloads,
      this.id,
      this.inheritsFrom,
      this.javaVersion,
      this.libraries,
      this.logging,
      this.mainClass,
      this.minimumLauncherVersion,
      this.releaseTime,
      this.time,
      this.type);

  final Arguments? arguments;
  final String? minecraftArguments;
  final AssetIndex assetIndex;
  String? assets;
  int? complianceLevel;
  final Downloads downloads;
  final String id;
  String? inheritsFrom;
  JavaVersion? javaVersion;
  final List<Library> libraries;
  Logging? logging;
  final String mainClass;
  int? minimumLauncherVersion;
  DateTime? releaseTime;
  DateTime? time;
  final VersionType type;

  factory Version.fromJson(Map<String, dynamic> json) => _$VersionFromJson(json);

  Map<String, dynamic> toJson() => _$VersionToJson(this);
}
