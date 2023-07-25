// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetIndex _$AssetIndexFromJson(Map<String, dynamic> json) => AssetIndex(
      json['id'] as String,
      json['sha1'] as String,
      json['size'] as int,
      json['totalSize'] as int,
      json['url'] as String,
    );

Map<String, dynamic> _$AssetIndexToJson(AssetIndex instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sha1': instance.sha1,
      'size': instance.size,
      'totalSize': instance.totalSize,
      'url': instance.url,
    };
