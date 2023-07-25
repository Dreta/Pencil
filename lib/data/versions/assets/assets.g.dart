// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Assets _$AssetsFromJson(Map<String, dynamic> json) => Assets(
      (json['objects'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Asset.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$AssetsToJson(Assets instance) => <String, dynamic>{
      'objects': instance.objects,
    };
