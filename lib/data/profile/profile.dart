import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  Profile(this.uuid, this.name, this.version, this.img, this.lastUsed, this.quickPlayMode, this.quickPlayHost,
      this.resolutionWidth, this.resolutionHeight, this.enabledDemoMode, this.jvmArguments, this.gameArguments);

  String uuid;
  String name;
  String version;
  @JsonKey(defaultValue: 'asset:assets/images/profiles/1.png')
  String img;
  DateTime lastUsed;

  @JsonKey(defaultValue: QuickPlayMode.disabled)
  QuickPlayMode quickPlayMode;
  String? quickPlayHost;

  int? resolutionWidth;
  int? resolutionHeight;

  @JsonKey(defaultValue: false)
  bool enabledDemoMode;

  @JsonKey(defaultValue: '-Xmx2G -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M')
  String jvmArguments;
  @JsonKey(defaultValue: '')
  String gameArguments;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable()
class Profiles {
  Profiles(this.selectedProfile, this.profiles);

  String? selectedProfile; // uuid
  @JsonKey(defaultValue: {})
  Map<String, Profile> profiles; // uuid to account

  factory Profiles.fromJson(Map<String, dynamic> json) => _$ProfilesFromJson(json);

  Map<String, dynamic> toJson() => _$ProfilesToJson(this);
}

enum QuickPlayMode { disabled, singleplayer, multiplayer, realms }
