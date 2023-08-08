// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rule _$RuleFromJson(Map<String, dynamic> json) => Rule(
      json['action'] as String,
      (json['features'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ),
      json['os'] == null
          ? null
          : OS.fromJson(json['os'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RuleToJson(Rule instance) => <String, dynamic>{
      'action': instance.action,
      'features': instance.features,
      'os': instance.os,
    };

OS _$OSFromJson(Map<String, dynamic> json) => OS(
      json['name'] as String?,
      json['version'] as String?,
      json['arch'] as String?,
    );

Map<String, dynamic> _$OSToJson(OS instance) => <String, dynamic>{
      'name': instance.name,
      'version': instance.version,
      'arch': instance.arch,
    };
