import 'package:flutter/material.dart';
import 'package:pencil/data/settings/settings_provider.dart';
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
              Container(margin: const EdgeInsets.only(bottom: 24), child: Text('Game', style: theme.textTheme.headlineLarge)),
              Container(margin: const EdgeInsets.only(top: 8), child: Text('Storage', style: theme.textTheme.headlineSmall)),
              DirectoryTile(
                  icon: const Icon(Icons.gamepad),
                  title: 'Versions Directory',
                  dialogTitle: 'Choose Versions Directory',
                  subtitle: settings.data.game!.versionsDirectory!,
                  onChanged: (directory) {
                    settings.data.game!.versionsDirectory = directory;
                  }),
              DirectoryTile(
                  icon: const Icon(Icons.music_note),
                  title: 'Assets Directory',
                  dialogTitle: 'Choose Assets Directory',
                  subtitle: settings.data.game!.assetsDirectory!,
                  onChanged: (directory) {
                    settings.data.game!.assetsDirectory = directory;
                  }),
              DirectoryTile(
                  icon: const Icon(Icons.book),
                  title: 'Libraries Directory',
                  dialogTitle: 'Choose Libraries Directory',
                  subtitle: settings.data.game!.librariesDirectory!,
                  onChanged: (directory) {
                    settings.data.game!.librariesDirectory = directory;
                  })
            ])));
  }
}
