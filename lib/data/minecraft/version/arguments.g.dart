// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arguments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Arguments _$ArgumentsFromJson(Map<String, dynamic> json) => Arguments(
      json['game'] as List<dynamic>,
      json['jvm'] as List<dynamic>,
    );

Map<String, dynamic> _$ArgumentsToJson(Arguments instance) => <String, dynamic>{
      'game': instance.game,
      'jvm': instance.jvm,
    };

PlatformArgument _$PlatformArgumentFromJson(Map<String, dynamic> json) =>
    PlatformArgument(
      (json['rules'] as List<dynamic>)
          .map((e) => Rule.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['value'],
    );

Map<String, dynamic> _$PlatformArgumentToJson(PlatformArgument instance) =>
    <String, dynamic>{
      'rules': instance.rules,
      'value': instance.value,
    };
