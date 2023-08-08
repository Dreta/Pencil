import 'package:json_annotation/json_annotation.dart';

part 'java_version.g.dart';

@JsonSerializable()
class JavaVersion {
  JavaVersion(this.component, this.majorVersion);

  String? component;
  final int majorVersion;

  factory JavaVersion.fromJson(Map<String, dynamic> json) => _$JavaVersionFromJson(json);

  Map<String, dynamic> toJson() => _$JavaVersionToJson(this);
}
