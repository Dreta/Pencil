import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pencil/constants.dart';
import 'package:pencil/pages/settings/about.dart';
import 'package:pencil/pages/settings/game.dart';
import 'package:pencil/pages/settings/java.dart';
import 'package:pencil/pages/settings/launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _settingsIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      NavigationDrawer(
          selectedIndex: _settingsIndex,
          onDestinationSelected: (index) {
            setState(() {
              _settingsIndex = index;
            });
          },
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 16, 16),
                child: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.title'), style: theme.textTheme.headlineMedium)),
            NavigationDrawerDestination(icon: const Icon(Icons.airplanemode_active), label: I18nText('settings.launcher.title')),
            NavigationDrawerDestination(icon: const Icon(Icons.gamepad), label: I18nText('settings.game.title')),
            NavigationDrawerDestination(icon: const Icon(Icons.coffee), label: I18nText('settings.java.title')),
            NavigationDrawerDestination(icon: const Icon(Icons.book), label: I18nText('settings.about.entry'))
          ]),
      Expanded(child: const [SettingsLauncher(), SettingsGame(), SettingsJava(), SettingsAbout()][_settingsIndex])
    ]);
  }
}
