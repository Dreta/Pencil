import 'package:json_annotation/json_annotation.dart';
import 'package:pencil/data/versions/assets/asset.dart';

part 'assets.g.dart';

@JsonSerializable()
class Assets {
  Assets(this.objects);

  final Map<String, Asset> objects;

  factory Assets.fromJson(Map<String, dynamic> json) => _$AssetsFromJson(json);

  Map<String, dynamic> toJson() => _$AssetsToJson(this);
}
