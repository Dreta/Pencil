import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pencil/constants.dart';
import 'package:pencil/data/pencil/host.dart';
import 'package:pencil/data/pencil/settings/settings_data.dart';
import 'package:pencil/data/pencil/settings/settings_provider.dart';
import 'package:pencil/pages/settings/tiles.dart';
import 'package:provider/provider.dart';

class SettingsLauncher extends StatefulWidget {
  const SettingsLauncher({super.key});

  @override
  State<SettingsLauncher> createState() => _SettingsLauncherState();
}

class _SettingsLauncherState extends State<SettingsLauncher> {
  late HostPresetType hostPreset;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SettingsProvider settings = Provider.of<SettingsProvider>(context);
    hostPreset = settings.data.launcher!.host!.preset;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingsProvider settings = Provider.of<SettingsProvider>(context);

    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(56),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(margin: const EdgeInsets.only(bottom: 24), child: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.title'), style: theme.textTheme.headlineLarge)),
              Container(margin: const EdgeInsets.only(top: 8), child: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.storage.title'), style: theme.textTheme.headlineSmall)),
              DirectoryTile(
                  icon: const Icon(Icons.gamepad),
                  title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.storage.profilesDir'),
                  dialogTitle: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.storage.chooseProfilesDir'),
                  subtitle: settings.data.launcher!.profilesDirectory!,
                  onChanged: (directory) {
                    settings.data.launcher!.profilesDirectory = directory;
                  }),
              DirectoryTile(
                  icon: const Icon(Icons.image),
                  title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.storage.imgDir'),
                  dialogTitle: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.storage.chooseImgDir'),
                  subtitle: settings.data.launcher!.imagesDirectory!,
                  onChanged: (directory) {
                    settings.data.launcher!.imagesDirectory = directory;
                  }),
              Container(margin: const EdgeInsets.only(top: 8), child: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.profiles.title'), style: theme.textTheme.headlineSmall)),
              BooleanTile(
                  icon: const Icon(Icons.list),
                  title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.profiles.showStable'),
                  value: settings.data.launcher!.showReleases!,
                  onChanged: (value) {
                    settings.data.launcher!.showReleases = value;
                  }),
              BooleanTile(
                  icon: const Icon(Icons.fast_forward),
                  title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.profiles.showSnapshot'),
                  value: settings.data.launcher!.showSnapshots!,
                  onChanged: (value) {
                    settings.data.launcher!.showSnapshots = value;
                  }),
              BooleanTile(
                  icon: const Icon(Icons.history),
                  title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.profiles.showHistorical'),
                  value: settings.data.launcher!.showHistorical!,
                  onChanged: (value) {
                    settings.data.launcher!.showHistorical = value;
                  }),
              EnumTile(
                  icon: const Icon(Icons.sort),
                  title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.profiles.profileSort.title'),
                  value: settings.data.launcher!.profileSort!,
                  mapping: {ProfileSortType.lastPlayed: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.profiles.profileSort.byLastPlayed'), ProfileSortType.name: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.profiles.profileSort.byName')},
                  onChanged: (value) {
                    settings.data.launcher!.profileSort = value;
                  }),
              BooleanTile(
                  icon: const Icon(Icons.remove_red_eye),
                  title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.profiles.autoHide'),
                  value: settings.data.launcher!.hideLauncherAfterStart!,
                  onChanged: (value) {
                    settings.data.launcher!.hideLauncherAfterStart = value;
                  }),
              Container(
                  margin: const EdgeInsets.only(top: 8), child: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.title'), style: theme.textTheme.headlineSmall)),
              EnumTile(
                  icon: const Icon(Icons.menu),
                  title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.preset'),
                  value: hostPreset,
                  mapping: {
                    HostPresetType.official: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.presetOfficial'),
                    HostPresetType.bmclapi: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.presetBMCL'),
                    HostPresetType.custom: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.presetCustom')
                  },
                  onChanged: (value) {
                    if (value == HostPresetType.official) {
                      settings.data.launcher!.host = kHostPresetOfficial;
                    } else if (value == HostPresetType.bmclapi) {
                      settings.data.launcher!.host = kHostPresetBMCLAPI;
                    } else {
                      settings.data.launcher!.host!.preset = HostPresetType.custom;
                    }
                  }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.launcherMeta'),
                    dialogTitle: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.setLauncherMeta'),
                    value: settings.data.launcher!.host!.launcherMeta,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.launcherMeta = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.pistonMeta'),
                    dialogTitle: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.setPistonMeta'),
                    value: settings.data.launcher!.host!.pistonMeta,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.pistonMeta = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.resources'),
                    dialogTitle: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.setResources'),
                    value: settings.data.launcher!.host!.resources,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.resources = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.libraries'),
                    dialogTitle: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.setLibraries'),
                    value: settings.data.launcher!.host!.libraries,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.libraries = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.forge'),
                    dialogTitle: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.setForge'),
                    value: settings.data.launcher!.host!.forge,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.forge = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.fabricMeta'),
                    dialogTitle: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.setFabricMeta'),
                    value: settings.data.launcher!.host!.fabricMeta,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.fabricMeta = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.fabricMaven'),
                    dialogTitle: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.setFabricMaven'),
                    value: settings.data.launcher!.host!.fabricMaven,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.fabricMaven = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.quiltMeta'),
                    dialogTitle: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.setQuiltMeta'),
                    value: settings.data.launcher!.host!.quiltMeta,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.quiltMeta = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.quiltMaven'),
                    dialogTitle: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.setQuiltMaven'),
                    value: settings.data.launcher!.host!.quiltMaven,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.quiltMaven = value;
                    }),
              Container(margin: const EdgeInsets.only(top: 8), child: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.others.title'), style: theme.textTheme.headlineSmall)),
              BooleanTile(
                  icon: const Icon(Icons.update),
                  title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.others.checkUpdates'),
                  value: settings.data.launcher!.checkUpdates!,
                  onChanged: (value) {
                    settings.data.launcher!.checkUpdates = value;
                  }),
              EnumTile(
                  icon: const Icon(Icons.language),
                  title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.others.language'),
                  value: settings.data.launcher!.language,
                  mapping: {
                    'default': 'System Language',
                    for (String lang in kSupportedLanguages)
                      lang: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'languages.$lang')
                  },
                  onChanged: (value) {
                    settings.data.launcher!.language = value;
                  }),
            ])));
  }

  String? validateURL(String url) {
    Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) {
      return FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.urlErrors.valid');
    }
    if (url.endsWith('/')) {
      return FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.urlErrors.slash');
    }
    if (!uri.isScheme('https')) {
      return FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.launcher.host.urlErrors.https');
    }
    return null;
  }
}
