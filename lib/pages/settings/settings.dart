import 'package:flutter/material.dart';
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
                child: Text('Settings', style: theme.textTheme.headlineMedium)),
            const NavigationDrawerDestination(icon: Icon(Icons.airplanemode_active), label: Text('Launcher')),
            const NavigationDrawerDestination(icon: Icon(Icons.gamepad), label: Text('Game')),
            const NavigationDrawerDestination(icon: Icon(Icons.coffee), label: Text('Java')),
            const NavigationDrawerDestination(icon: Icon(Icons.book), label: Text('About'))
          ]),
      Expanded(child: const [SettingsLauncher(), SettingsGame(), SettingsJava(), SettingsAbout()][_settingsIndex])
    ]);
  }
}
