// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fabric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FabricCompatibleLoader _$FabricCompatibleLoaderFromJson(
        Map<String, dynamic> json) =>
    FabricCompatibleLoader(
      FabricVersion.fromJson(json['loader'] as Map<String, dynamic>),
      json['hashed'] == null
          ? null
          : FabricVersion.fromJson(json['hashed'] as Map<String, dynamic>),
      json['intermediary'] == null
          ? null
          : FabricVersion.fromJson(
              json['intermediary'] as Map<String, dynamic>),
      FabricLauncherMeta.fromJson(json['launcherMeta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FabricCompatibleLoaderToJson(
        FabricCompatibleLoader instance) =>
    <String, dynamic>{
      'loader': instance.loader,
      'hashed': instance.hashed,
      'intermediary': instance.intermediary,
      'launcherMeta': instance.launcherMeta,
    };

FabricLibrary _$FabricLibraryFromJson(Map<String, dynamic> json) =>
    FabricLibrary(
      json['name'] as String,
      json['url'] as String?,
    );

Map<String, dynamic> _$FabricLibraryToJson(FabricLibrary instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };

FabricLauncherMeta _$FabricLauncherMetaFromJson(Map<String, dynamic> json) =>
    FabricLauncherMeta(
      json['version'] as int,
      FabricLibraries.fromJson(json['libraries'] as Map<String, dynamic>),
      json['mainClass'],
    )..arguments = json['arguments'] == null
        ? null
        : FabricArguments.fromJson(json['arguments'] as Map<String, dynamic>);

Map<String, dynamic> _$FabricLauncherMetaToJson(FabricLauncherMeta instance) =>
    <String, dynamic>{
      'version': instance.version,
      'libraries': instance.libraries,
      'arguments': instance.arguments,
      'mainClass': instance.mainClass,
    };

FabricLibraries _$FabricLibrariesFromJson(Map<String, dynamic> json) =>
    FabricLibraries(
      (json['client'] as List<dynamic>)
          .map((e) => FabricLibrary.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['common'] as List<dynamic>)
          .map((e) => FabricLibrary.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['server'] as List<dynamic>)
          .map((e) => FabricLibrary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FabricLibrariesToJson(FabricLibraries instance) =>
    <String, dynamic>{
      'client': instance.client,
      'common': instance.common,
      'server': instance.server,
    };

FabricArguments _$FabricArgumentsFromJson(Map<String, dynamic> json) =>
    FabricArguments(
      (json['client'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      (json['common'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      (json['server'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
    );

Map<String, dynamic> _$FabricArgumentsToJson(FabricArguments instance) =>
    <String, dynamic>{
      'client': instance.client,
      'common': instance.common,
      'server': instance.server,
    };

FabricMainClass _$FabricMainClassFromJson(Map<String, dynamic> json) =>
    FabricMainClass(
      json['client'] as String,
      json['server'] as String?,
      json['serverLauncher'] as String?,
    );

Map<String, dynamic> _$FabricMainClassToJson(FabricMainClass instance) =>
    <String, dynamic>{
      'client': instance.client,
      'server': instance.server,
      'serverLauncher': instance.serverLauncher,
    };

FabricVersion _$FabricVersionFromJson(Map<String, dynamic> json) =>
    FabricVersion(
      json['separator'] as String?,
      json['build'] as int?,
      json['maven'] as String,
      json['version'] as String,
      json['stable'] as bool?,
    );

Map<String, dynamic> _$FabricVersionToJson(FabricVersion instance) =>
    <String, dynamic>{
      'separator': instance.separator,
      'build': instance.build,
      'maven': instance.maven,
      'version': instance.version,
      'stable': instance.stable,
    };
