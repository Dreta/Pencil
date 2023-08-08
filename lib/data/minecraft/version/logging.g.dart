// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logging.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Logging _$LoggingFromJson(Map<String, dynamic> json) => Logging(
      ClientLogging.fromJson(json['client'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoggingToJson(Logging instance) => <String, dynamic>{
      'client': instance.client,
    };

ClientLogging _$ClientLoggingFromJson(Map<String, dynamic> json) =>
    ClientLogging(
      json['argument'] as String,
      ClientLoggingFile.fromJson(json['file'] as Map<String, dynamic>),
      json['type'] as String?,
    );

Map<String, dynamic> _$ClientLoggingToJson(ClientLogging instance) =>
    <String, dynamic>{
      'argument': instance.argument,
      'file': instance.file,
      'type': instance.type,
    };

ClientLoggingFile _$ClientLoggingFileFromJson(Map<String, dynamic> json) =>
    ClientLoggingFile(
      json['id'] as String,
      json['sha1'] as String?,
      json['size'] as int?,
      json['url'] as String,
    );

Map<String, dynamic> _$ClientLoggingFileToJson(ClientLoggingFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sha1': instance.sha1,
      'size': instance.size,
      'url': instance.url,
    };
