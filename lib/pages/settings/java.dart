import 'package:flutter/material.dart';
import 'package:pencil/data/settings/settings_provider.dart';
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
              Container(margin: const EdgeInsets.only(bottom: 24), child: Text('Java', style: theme.textTheme.headlineLarge)),
              BooleanTile(
                  icon: const Icon(Icons.coffee),
                  title: 'Automatically Download Java (Recommended)',
                  value: settings.data.java!.useManaged!,
                  onChanged: (value) {
                    settings.data.java!.useManaged = value;
                  }),
              DirectoryTile(
                  icon: const Icon(Icons.folder),
                  title: 'Modern Java Home (Java 17)',
                  dialogTitle: 'Set Modern Java Home',
                  subtitle: settings.data.java!.modernJavaHome!,
                  onChanged: (value) {
                    settings.data.java!.modernJavaHome = value;
                  }),
              DirectoryTile(
                  icon: const Icon(Icons.folder_copy),
                  title: 'Legacy Java Home (Java 8)',
                  dialogTitle: 'Set Legacy Java Home',
                  subtitle: settings.data.java!.legacyJavaHome!,
                  onChanged: (value) {
                    settings.data.java!.legacyJavaHome = value;
                  })
            ])));
  }
}
