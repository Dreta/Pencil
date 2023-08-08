import 'package:json_annotation/json_annotation.dart';

part 'host.g.dart';

get kHostPresetOfficial {
  return Host(
      HostPresetType.official,
      'https://launchermeta.mojang.com',
      'https://piston-meta.mojang.com',
      'https://resources.download.minecraft.net',
      'https://libraries.minecraft.net',
      'https://maven.neoforged.net',
      'https://meta.fabricmc.net',
      'https://maven.fabricmc.net',
      'https://meta.quiltmc.org',
      'https://maven.quiltmc.org');
}

get kHostPresetBMCLAPI {
  return Host(
      HostPresetType.bmclapi,
      'https://bmclapi2.bangbang93.com',
      'https://bmclapi2.bangbang93.com',
      'https://bmclapi2.bangbang93.com/assets',
      'https://bmclapi2.bangbang93.com/maven',
      'https://bmclapi2.bangbang93.com/maven',
      'https://bmclapi2.bangbang93.com/fabric-meta',
      'https://bmclapi2.bangbang93.com/maven',
      'https://meta.quiltmc.org',
      'https://maven.quiltmc.org');
}

@JsonSerializable()
class Host {
  Host(this.preset, this.launcherMeta, this.pistonMeta, this.resources, this.libraries, this.forge, this.fabricMeta,
      this.fabricMaven, this.quiltMeta, this.quiltMaven);

  HostPresetType preset;
  String launcherMeta;
  String pistonMeta;
  String resources;
  String libraries;
  String forge;
  String fabricMeta;
  String fabricMaven;
  String quiltMeta;
  String quiltMaven;

  String formatLink(String link) {
    return link
        .replaceAll('https://launchermeta.mojang.com', launcherMeta)
        .replaceAll('https://piston-meta.mojang.com', pistonMeta)
        .replaceAll('https://resources.download.minecraft.net', resources)
        .replaceAll('https://libraries.minecraft.net', libraries)
        .replaceAll('https://maven.neoforged.net', forge)
        .replaceAll('https://meta.fabricmc.net', fabricMeta)
        .replaceAll('https://maven.fabricmc.net', fabricMaven)
        .replaceAll('https://meta.quiltmc.org', quiltMeta)
        .replaceAll('https://maven.quiltmc.org', quiltMaven);
  }

  factory Host.fromJson(Map<String, dynamic> json) => _$HostFromJson(json);

  Map<String, dynamic> toJson() => _$HostToJson(this);
}

enum HostPresetType { custom, official, bmclapi }
