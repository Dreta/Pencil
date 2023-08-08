import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pencil/data/pencil/settings/settings_provider.dart';
import 'package:pencil/pages/settings/tiles.dart';
import 'package:provider/provider.dart';

class SettingsGame extends StatelessWidget {
  const SettingsGame({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingsProvider settings = Provider.of<SettingsProvider>(context);

    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(56),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(margin: const EdgeInsets.only(bottom: 24), child: Text(FlutterI18n.translate(context, 'settings.game.title'), style: theme.textTheme.headlineLarge)),
              Container(margin: const EdgeInsets.only(top: 8), child: Text(FlutterI18n.translate(context, 'settings.game.storage.title'), style: theme.textTheme.headlineSmall)),
              DirectoryTile(
                  icon: const Icon(Icons.gamepad),
                  title: FlutterI18n.translate(context, 'settings.game.storage.versionsDir'),
                  dialogTitle: FlutterI18n.translate(context, 'settings.game.storage.chooseVersionsDir'),
                  subtitle: settings.data.game!.versionsDirectory!,
                  onChanged: (directory) {
                    settings.data.game!.versionsDirectory = directory;
                  }),
              DirectoryTile(
                  icon: const Icon(Icons.music_note),
                  title: FlutterI18n.translate(context, 'settings.game.storage.assetsDir'),
                  dialogTitle: FlutterI18n.translate(context, 'settings.game.storage.chooseAssetsDir'),
                  subtitle: settings.data.game!.assetsDirectory!,
                  onChanged: (directory) {
                    settings.data.game!.assetsDirectory = directory;
                  }),
              DirectoryTile(
                  icon: const Icon(Icons.book),
                  title: FlutterI18n.translate(context, 'settings.game.storage.librariesDir'),
                  dialogTitle: FlutterI18n.translate(context, 'settings.game.storage.chooseLibrariesDir'),
                  subtitle: settings.data.game!.librariesDirectory!,
                  onChanged: (directory) {
                    settings.data.game!.librariesDirectory = directory;
                  })
            ])));
  }
}
