import 'package:json_annotation/json_annotation.dart';

part 'latest.g.dart';

@JsonSerializable()
class Latest {
  Latest(this.release, this.snapshot);

  final String release;
  final String snapshot;

  factory Latest.fromJson(Map<String, dynamic> json) => _$LatestFromJson(json);

  Map<String, dynamic> toJson() => _$LatestToJson(this);
}
