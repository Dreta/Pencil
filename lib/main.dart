import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/locale.dart' as intl;
import 'package:pencil/constants.dart';
import 'package:pencil/data/minecraft/manifest/version_manifest_provider.dart';
import 'package:pencil/data/pencil/account/accounts_provider.dart';
import 'package:pencil/data/pencil/profile/profiles_provider.dart';
import 'package:pencil/data/pencil/settings/settings_provider.dart';
import 'package:pencil/data/pencil/task/tasks_provider.dart';
import 'package:pencil/pages/base/base.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main(List<String> args) async {
  if (runWebViewTitleBarWidget(args)) {
    return;
  }
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const PencilBaseApp());

  doWhenWindowReady(() {
    setWindowTitle('Pencil');
    appWindow.minSize = const Size(600, 600);
    appWindow.size = const Size(1000, 700);
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class PencilBaseApp extends StatelessWidget {
  const PencilBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Product Sans'),
        displayMedium: TextStyle(fontFamily: 'Product Sans'),
        displaySmall: TextStyle(fontFamily: 'Product Sans'),
        headlineLarge: TextStyle(fontFamily: 'Product Sans'),
        headlineMedium: TextStyle(fontFamily: 'Product Sans'),
        headlineSmall: TextStyle(fontFamily: 'Product Sans'),
        titleLarge: TextStyle(fontFamily: 'Product Sans'),
        titleMedium: TextStyle(fontFamily: 'Product Sans'),
        titleSmall: TextStyle(fontFamily: 'Product Sans'),
        labelLarge: TextStyle(fontFamily: 'Product Sans'),
        labelSmall: TextStyle(fontFamily: 'Product Sans'),
        bodyLarge: TextStyle(fontFamily: 'Roboto'),
        bodyMedium: TextStyle(fontFamily: 'Roboto'),
        bodySmall: TextStyle(fontFamily: 'Roboto'));

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsProvider>(create: (_) => SettingsProvider()),
          ChangeNotifierProvider<AccountsProvider>(create: (_) => AccountsProvider()),
          ChangeNotifierProvider<TasksProvider>(create: (_) => TasksProvider()),
          ChangeNotifierProvider<VersionManifestProvider>(create: (_) => VersionManifestProvider()),
          ChangeNotifierProvider<ProfilesProvider>(create: (_) => ProfilesProvider())
        ],
        child: Consumer(
            builder: (context, provider, child) => DynamicColorBuilder(builder: (light, dark) {
                  SettingsProvider settings = Provider.of<SettingsProvider>(context);
                  intl.Locale? parsedLocale = settings.data.launcher!.language! == 'default'
                      ? null
                      : intl.Locale.tryParse(settings.data.launcher!.language!);
                  return MaterialApp(
                      title: 'Pencil',
                      debugShowCheckedModeBanner: false,
                      navigatorKey: kBaseNavigatorKey,
                      theme: ThemeData(
                          colorScheme: light ?? ColorScheme.fromSeed(seedColor: Colors.lightBlue),
                          useMaterial3: true,
                          textTheme: textTheme),
                      darkTheme: ThemeData(
                          colorScheme: dark ?? ColorScheme.fromSeed(seedColor: Colors.lightBlue, brightness: Brightness.dark),
                          useMaterial3: true,
                          textTheme: textTheme),
                      localizationsDelegates: [
                        FlutterI18nDelegate(
                            translationLoader: FileTranslationLoader(
                                useCountryCode: true,
                                fallbackFile: 'en_US',
                                forcedLocale: parsedLocale != null
                                    ? Locale.fromSubtags(
                                        languageCode: parsedLocale.languageCode,
                                        countryCode: parsedLocale.countryCode,
                                        scriptCode: parsedLocale.scriptCode)
                                    : null)),
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate
                      ],
                      builder: FlutterI18n.rootAppBuilder(),
                      home: const PencilBase());
                })));
  }
}
