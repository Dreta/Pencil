import 'package:json_annotation/json_annotation.dart';

part 'asset_index.g.dart';

@JsonSerializable()
class AssetIndex {
  AssetIndex(this.id, this.sha1, this.size, this.totalSize, this.url);

  final String id;
  final String sha1;
  final int size;
  final int totalSize;
  final String url;

  factory AssetIndex.fromJson(Map<String, dynamic> json) => _$AssetIndexFromJson(json);

  Map<String, dynamic> toJson() => _$AssetIndexToJson(this);
}
