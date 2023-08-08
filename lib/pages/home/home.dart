import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pencil/constants.dart';
import 'package:pencil/pages/home/welcome.dart';

import 'news.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(56),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'home.title'), style: theme.textTheme.headlineLarge)),
              Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'home.welcomeHeader'), style: theme.textTheme.headlineSmall)),
              Container(margin: const EdgeInsets.only(bottom: 16), child: const Welcome()),
              Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'home.newsHeader'), style: theme.textTheme.headlineSmall)),
              const News()
            ])));
  }
}
