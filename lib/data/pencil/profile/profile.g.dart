// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      json['uuid'] as String,
      json['name'] as String,
      json['version'] as String,
      json['img'] as String? ?? 'asset:assets/images/profiles/23.png',
      DateTime.parse(json['lastUsed'] as String),
      json['lastDownloaded'] == null
          ? null
          : DateTime.parse(json['lastDownloaded'] as String),
      $enumDecodeNullable(_$QuickPlayModeEnumMap, json['quickPlayMode']) ??
          QuickPlayMode.disabled,
      json['quickPlayHost'] as String?,
      json['resolutionWidth'] as int?,
      json['resolutionHeight'] as int?,
      json['enabledDemoMode'] as bool? ?? false,
      json['jvmArguments'] as String? ??
          '-Xmx2G -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M',
      json['gameArguments'] as String? ?? '',
      json['environment'] as String? ?? '',
      $enumDecodeNullable(_$AddonTypeEnumMap, json['addonType']) ??
          AddonType.disabled,
      json['addonVersion'] as String?,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'version': instance.version,
      'img': instance.img,
      'lastUsed': instance.lastUsed.toIso8601String(),
      'lastDownloaded': instance.lastDownloaded?.toIso8601String(),
      'quickPlayMode': _$QuickPlayModeEnumMap[instance.quickPlayMode]!,
      'quickPlayHost': instance.quickPlayHost,
      'resolutionWidth': instance.resolutionWidth,
      'resolutionHeight': instance.resolutionHeight,
      'enabledDemoMode': instance.enabledDemoMode,
      'jvmArguments': instance.jvmArguments,
      'gameArguments': instance.gameArguments,
      'environment': instance.environment,
      'addonType': _$AddonTypeEnumMap[instance.addonType]!,
      'addonVersion': instance.addonVersion,
    };

const _$QuickPlayModeEnumMap = {
  QuickPlayMode.disabled: 'disabled',
  QuickPlayMode.singleplayer: 'singleplayer',
  QuickPlayMode.multiplayer: 'multiplayer',
  QuickPlayMode.realms: 'realms',
};

const _$AddonTypeEnumMap = {
  AddonType.disabled: 'disabled',
  AddonType.forge: 'forge',
  AddonType.fabric: 'fabric',
  AddonType.quilt: 'quilt',
};

Profiles _$ProfilesFromJson(Map<String, dynamic> json) => Profiles(
      json['selectedProfile'] as String?,
      (json['profiles'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Profile.fromJson(e as Map<String, dynamic>)),
          ) ??
          {},
    );

Map<String, dynamic> _$ProfilesToJson(Profiles instance) => <String, dynamic>{
      'selectedProfile': instance.selectedProfile,
      'profiles': instance.profiles,
    };
