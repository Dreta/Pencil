import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:pencil/data/profile/profile.dart';

part 'rule.g.dart';

@JsonSerializable()
class Rule {
  Rule(this.action, this.features, this.os);

  final String action;
  Map<String, bool>? features;
  OS? os;

  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);

  Map<String, dynamic> toJson() => _$RuleToJson(this);

  Future<bool> matches(Profile? profile) async {
    return (os == null ? true : (await os!.matches())) && (profile == null ? true : profileMatches(profile));
  }

  bool hasFeature(String feature) {
    return features!.containsKey(feature) && features![feature]!;
  }

  bool profileMatches(Profile profile) {
    if (features == null) {
      return true;
    }
    bool matches = true;
    if (hasFeature('has_custom_resolution') && (profile.resolutionHeight == null || profile.resolutionWidth == null)) {
      matches = false;
    }
    if (hasFeature('is_demo_user') && !profile.enabledDemoMode) {
      matches = false;
    }
    if (hasFeature('has_quick_plays_support') && profile.quickPlayMode == QuickPlayMode.disabled) {
      matches = false;
    }
    if (hasFeature('is_quick_play_singleplayer') && profile.quickPlayMode != QuickPlayMode.singleplayer) {
      matches = false;
    }
    if (hasFeature('is_quick_play_multiplayer') && profile.quickPlayMode != QuickPlayMode.multiplayer) {
      matches = false;
    }
    if (hasFeature('is_quick_play_realms') && profile.quickPlayMode != QuickPlayMode.realms) {
      matches = false;
    }
    return matches;
  }
}

@JsonSerializable()
class OS {
  OS(this.name, this.version, this.arch);

  String? name;
  String? version;
  String? arch;

  Future<bool> matches() async {
    if ((name == 'linux' && !Platform.isLinux) ||
        (name == 'osx' && !Platform.isMacOS) ||
        (name == 'windows' && !Platform.isWindows)) {
      return false;
    }
    String currentArch = await getArchitecture();
    if (arch != null &&
        ((arch!.contains('x86') && currentArch != 'x86_64' && currentArch != 'x86' && currentArch != 'amd64') ||
            (arch!.contains('arm') && !currentArch.contains('arm')))) {
      return false;
    }
    if (version != null && !RegExp(version!).hasMatch(Platform.operatingSystemVersion)) {
      return false;
    }
    return true;
  }

  static Future<String> getArchitecture() async {
    if (Platform.isWindows) {
      return (Platform.environment['PROCESSOR_ARCHITECTURE'] ?? 'x86_64').toLowerCase();
    } else {
      var info = await Process.run('uname', ['-m']);
      var cpu = info.stdout.toString().replaceAll('\n', '');
      return cpu.toLowerCase();
    }
  }

  factory OS.fromJson(Map<String, dynamic> json) => _$OSFromJson(json);

  Map<String, dynamic> toJson() => _$OSToJson(this);
}
