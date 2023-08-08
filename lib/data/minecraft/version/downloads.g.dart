// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloads.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Downloads _$DownloadsFromJson(Map<String, dynamic> json) => Downloads(
      LauncherDownload.fromJson(json['client'] as Map<String, dynamic>),
      json['client_mappings'] == null
          ? null
          : LauncherDownload.fromJson(
              json['client_mappings'] as Map<String, dynamic>),
      json['server'] == null
          ? null
          : LauncherDownload.fromJson(json['server'] as Map<String, dynamic>),
      json['server_mappings'] == null
          ? null
          : LauncherDownload.fromJson(
              json['server_mappings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DownloadsToJson(Downloads instance) => <String, dynamic>{
      'client': instance.client,
      'client_mappings': instance.client_mappings,
      'server': instance.server,
      'server_mappings': instance.server_mappings,
    };

LauncherDownload _$LauncherDownloadFromJson(Map<String, dynamic> json) =>
    LauncherDownload(
      json['sha1'] as String?,
      json['size'] as int?,
      json['url'] as String,
    );

Map<String, dynamic> _$LauncherDownloadToJson(LauncherDownload instance) =>
    <String, dynamic>{
      'sha1': instance.sha1,
      'size': instance.size,
      'url': instance.url,
    };
