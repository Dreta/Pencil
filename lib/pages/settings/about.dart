import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pencil/constants.dart';

class SettingsAbout extends StatelessWidget {
  const SettingsAbout({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 96,
          width: 96,
          child: Image.asset('assets/icons/icon-circle.png',
              fit: BoxFit.contain, isAntiAlias: true, filterQuality: FilterQuality.medium)),
      Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.about.name'),
              style: theme.textTheme.headlineMedium)),
      Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.about.title'), style: theme.textTheme.bodyMedium),
      Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'settings.about.disclaimer'),
          style: theme.textTheme.bodyMedium)
    ]));
  }
}
