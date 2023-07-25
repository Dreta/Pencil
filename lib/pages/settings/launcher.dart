import 'package:flutter/material.dart';
import 'package:pencil/data/host.dart';
import 'package:pencil/data/settings/settings_provider.dart';
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
              Container(margin: const EdgeInsets.only(bottom: 24), child: Text('Launcher', style: theme.textTheme.headlineLarge)),
              Container(margin: const EdgeInsets.only(top: 8), child: Text('Storage', style: theme.textTheme.headlineSmall)),
              DirectoryTile(
                  icon: const Icon(Icons.gamepad),
                  title: 'Profiles Directory',
                  dialogTitle: 'Choose Profiles Directory',
                  subtitle: '${settings.data.launcher!.profilesDirectory!} (This is not .minecraft)',
                  onChanged: (directory) {
                    settings.data.launcher!.profilesDirectory = directory;
                  }),
              DirectoryTile(
                  icon: const Icon(Icons.image),
                  title: 'Images Directory',
                  dialogTitle: 'Choose Images Directory',
                  subtitle: settings.data.launcher!.imagesDirectory!,
                  onChanged: (directory) {
                    settings.data.launcher!.imagesDirectory = directory;
                  }),
              Container(margin: const EdgeInsets.only(top: 8), child: Text('Releases', style: theme.textTheme.headlineSmall)),
              BooleanTile(
                  icon: const Icon(Icons.list),
                  title: 'Show Stable Releases',
                  value: settings.data.launcher!.showReleases!,
                  onChanged: (value) {
                    settings.data.launcher!.showReleases = value;
                  }),
              BooleanTile(
                  icon: const Icon(Icons.fast_forward),
                  title: 'Show Snapshot Releases',
                  value: settings.data.launcher!.showSnapshots!,
                  onChanged: (value) {
                    settings.data.launcher!.showSnapshots = value;
                  }),
              BooleanTile(
                  icon: const Icon(Icons.history),
                  title: 'Show Historical Releases',
                  value: settings.data.launcher!.showHistorical!,
                  onChanged: (value) {
                    settings.data.launcher!.showHistorical = value;
                  }),
              Container(
                  margin: const EdgeInsets.only(top: 8), child: Text('Download Sources', style: theme.textTheme.headlineSmall)),
              EnumTile(
                  icon: const Icon(Icons.menu),
                  title: 'Download Preset',
                  value: hostPreset,
                  mapping: const {
                    HostPresetType.official: 'Official',
                    HostPresetType.bmclapi: 'BMCLAPI (For users in mainland China)',
                    HostPresetType.custom: 'Custom'
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
                    title: 'Launcher Meta Host',
                    dialogTitle: 'Set Launcher Meta Host',
                    value: settings.data.launcher!.host!.launcherMeta,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.launcherMeta = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: 'Piston Meta Host',
                    dialogTitle: 'Set Piston Meta Host',
                    value: settings.data.launcher!.host!.pistonMeta,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.pistonMeta = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: 'Resources Host',
                    dialogTitle: 'Set Resources Host',
                    value: settings.data.launcher!.host!.resources,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.resources = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: 'Libraries Host',
                    dialogTitle: 'Set Libraries Host',
                    value: settings.data.launcher!.host!.libraries,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.libraries = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: 'Forge Host',
                    dialogTitle: 'Set Forge Host',
                    value: settings.data.launcher!.host!.forge,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.forge = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: 'Fabric Meta Host',
                    dialogTitle: 'Set Fabric Meta Host',
                    value: settings.data.launcher!.host!.fabricMeta,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.fabricMeta = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: 'Fabric Maven Host',
                    dialogTitle: 'Set Fabric Maven Host',
                    value: settings.data.launcher!.host!.fabricMaven,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.fabricMaven = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: 'Quilt Meta Host',
                    dialogTitle: 'Set Quilt Host',
                    value: settings.data.launcher!.host!.quiltMeta,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.quiltMeta = value;
                    }),
              if (hostPreset == HostPresetType.custom)
                TextInputTile(
                    icon: const Icon(Icons.link),
                    title: 'Quilt Maven Host',
                    dialogTitle: 'Set Quilt Maven Host',
                    value: settings.data.launcher!.host!.quiltMaven,
                    isValid: validateURL,
                    onChanged: (value) {
                      settings.data.launcher!.host!.quiltMaven = value;
                    }),
              Container(margin: const EdgeInsets.only(top: 8), child: Text('Others', style: theme.textTheme.headlineSmall)),
              BooleanTile(
                  icon: const Icon(Icons.update),
                  title: 'Automatically Check Updates',
                  value: settings.data.launcher!.checkUpdates!,
                  onChanged: (value) {
                    settings.data.launcher!.checkUpdates = value;
                  }),
              BooleanTile(
                  icon: const Icon(Icons.phone_in_talk),
                  title: 'Enable Anonymous Telemetry',
                  value: settings.data.launcher!.telemetry!,
                  onChanged: (value) {
                    settings.data.launcher!.telemetry = value;
                  })
            ])));
  }

  String? validateURL(String url) {
    Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) {
      return 'Must be a valid URL';
    }
    if (url.endsWith('/')) {
      return 'Must not end with a slash';
    }
    if (!uri.isScheme('https')) {
      return 'Protocol must be HTTPS';
    }
    return null;
  }
}
