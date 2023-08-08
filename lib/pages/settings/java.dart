import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pencil/constants.dart';
import 'package:pencil/data/pencil/settings/settings_provider.dart';
import 'package:pencil/pages/settings/tiles.dart';
import 'package:provider/provider.dart';

class SettingsJava extends StatelessWidget {
  const SettingsJava({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingsProvider settings = Provider.of<SettingsProvider>(context);

    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(56),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(margin: const EdgeInsets.only(bottom: 24), child: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.java.title'), style: theme.textTheme.headlineLarge)),
              BooleanTile(
                  icon: const Icon(Icons.coffee),
                  title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.java.autoDownload'),
                  value: settings.data.java!.useManaged!,
                  onChanged: (value) {
                    settings.data.java!.useManaged = value;
                  }),
              DirectoryTile(
                  icon: const Icon(Icons.folder),
                  title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.java.modernHome'),
                  dialogTitle: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.java.setModernHome'),
                  subtitle: settings.data.java!.modernJavaHome!,
                  onChanged: (value) {
                    settings.data.java!.modernJavaHome = value;
                  }),
              DirectoryTile(
                  icon: const Icon(Icons.folder_copy),
                  title: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.java.legacyHome'),
                  dialogTitle: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.java.setLegacyHome'),
                  subtitle: settings.data.java!.legacyJavaHome!,
                  onChanged: (value) {
                    settings.data.java!.legacyJavaHome = value;
                  })
            ])));
  }
}
