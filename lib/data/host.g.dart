// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Host _$HostFromJson(Map<String, dynamic> json) => Host(
      $enumDecode(_$HostPresetTypeEnumMap, json['preset']),
      json['launcherMeta'] as String,
      json['pistonMeta'] as String,
      json['resources'] as String,
      json['libraries'] as String,
      json['forge'] as String,
      json['fabricMeta'] as String,
      json['fabricMaven'] as String,
      json['quiltMeta'] as String,
      json['quiltMaven'] as String,
    );

Map<String, dynamic> _$HostToJson(Host instance) => <String, dynamic>{
      'preset': _$HostPresetTypeEnumMap[instance.preset]!,
      'launcherMeta': instance.launcherMeta,
      'pistonMeta': instance.pistonMeta,
      'resources': instance.resources,
      'libraries': instance.libraries,
      'forge': instance.forge,
      'fabricMeta': instance.fabricMeta,
      'fabricMaven': instance.fabricMaven,
      'quiltMeta': instance.quiltMeta,
      'quiltMaven': instance.quiltMaven,
    };

const _$HostPresetTypeEnumMap = {
  HostPresetType.custom: 'custom',
  HostPresetType.official: 'official',
  HostPresetType.bmclapi: 'bmclapi',
};
