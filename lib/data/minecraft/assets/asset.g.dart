// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      json['hash'] as String,
      json['size'] as int?,
    );

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'hash': instance.hash,
      'size': instance.size,
    };
