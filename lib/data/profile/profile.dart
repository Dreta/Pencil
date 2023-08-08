import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pencil/constants.dart';
import 'package:pencil/data/account/accounts_provider.dart';
import 'package:pencil/data/modloaders/addon.dart';
import 'package:pencil/data/modloaders/fabric_compatible_addon.dart';
import 'package:pencil/data/profile/profiles_provider.dart';
import 'package:pencil/launch/download_utils.dart';
import 'package:pencil/launch/launch_utils.dart';
import 'package:provider/provider.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  Profile(
      this.uuid,
      this.name,
      this.version,
      this.img,
      this.lastUsed,
      this.lastDownloaded,
      this.quickPlayMode,
      this.quickPlayHost,
      this.resolutionWidth,
      this.resolutionHeight,
      this.enabledDemoMode,
      this.jvmArguments,
      this.gameArguments,
      this.addonType,
      this.addonVersion)
      : addon = addonType == AddonType.disabled ? null : addonType.addon;

  String uuid;
  String name;
  String version;
  @JsonKey(defaultValue: 'asset:assets/images/profiles/23.png')
  String img;
  DateTime lastUsed;

  DateTime? lastDownloaded;

  @JsonKey(defaultValue: QuickPlayMode.disabled)
  QuickPlayMode quickPlayMode;
  String? quickPlayHost;

  int? resolutionWidth;
  int? resolutionHeight;

  @JsonKey(defaultValue: false)
  bool enabledDemoMode;

  @JsonKey(
      defaultValue:
          '-Xmx2G -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M')
  String jvmArguments;
  @JsonKey(defaultValue: '')
  String gameArguments;

  @JsonKey(defaultValue: AddonType.disabled)
  AddonType addonType;
  String? addonVersion;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool launching = false;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Addon? addon;

  Future<void> play(BuildContext context, bool confirm) async {
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context, listen: false);
    AccountsProvider accounts = Provider.of<AccountsProvider>(context, listen: false);
    if (launching) {
      showDialog(
          context: kBaseNavigatorKey.currentContext!,
          builder: (context) => AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                  title: const Text('Already running'),
                  content: const Text('You can\'t run the same profile at the same time.'),
                  actions: [
                    TextButton(
                        child: const Text('Confirm'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ]));
      return;
    }
    if (profiles.isRunning && !confirm) {
      showDialog(
          context: kBaseNavigatorKey.currentContext!,
          builder: (context) => AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                  title: const Text('Another game is already running'),
                  content: const Text('Running multiple games simultaneously may cause conflicts. Do you wish to continue?'),
                  actions: [
                    TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    TextButton(
                        child: const Text('Continue Anyways'),
                        onPressed: () {
                          play(context, true);
                        })
                  ]));
      return;
    }
    if (accounts.accounts.currentAccount == null) {
      showDialog(
          context: kBaseNavigatorKey.currentContext!,
          builder: (context) => AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                  title: const Text('No Account Selected'),
                  content: const Text('You must select an account before starting the game.'),
                  actions: [
                    TextButton(
                        child: const Text('Confirm'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ]));
      return;
    }

    launching = true;
    profiles.notify();

    if ((lastDownloaded != null && DateTime.now().difference(lastDownloaded!).inDays < 3) ||
        await DownloadUtils.downloadProfile(kBaseNavigatorKey.currentContext!, this)) {
      await Future.delayed(const Duration(seconds: 2)); // Magic, do not remove (for Linux at least)
      await LaunchUtils.launchGame(
          kBaseNavigatorKey.currentContext!, this, accounts.accounts.accounts[accounts.accounts.currentAccount!]!);
    }

    launching = false;
    profiles.notify();
  }

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

enum AddonType {
  disabled,
  forge,
  fabric,
  quilt;

  Addon get addon {
    return {
      AddonType.fabric: FabricCompatibleAddon(type: FabricType.fabric),
      AddonType.quilt: FabricCompatibleAddon(type: FabricType.quilt)
    }[this]!;
  }
}
