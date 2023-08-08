import 'dart:async';
import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pencil/constants.dart';
import 'package:pencil/data/pencil/account/accounts_provider.dart';
import 'package:pencil/data/pencil/task/tasks_provider.dart';
import 'package:pencil/data/minecraft/manifest/version_manifest_provider.dart';
import 'package:pencil/launch/java_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class StartupTasks {
  static Future<void> refreshAccounts(BuildContext context) async {
    if (!(await Provider.of<AccountsProvider>(context, listen: false)
            .refreshAccounts(context, Provider.of<TasksProvider>(context, listen: false))) &&
        context.mounted) {
      ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: I18nText('startupTasks.reauthFailed')));
    }
  }

  static Future<void> checkWebviewAvailability(BuildContext context) async {
    if (!(await WebviewWindow.isWebviewAvailable()) && context.mounted) {
      showDialog(
          context: kBaseNavigatorKey.currentContext!,
          barrierDismissible: Platform.isMacOS,
          builder: (context) => AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                  title: I18nText(Platform.isMacOS ? 'startupTasks.webviewUnavailable.macOSTitle' : 'startupTasks.webviewUnavailable.title'),
                  content: I18nText(Platform.isWindows
                      ? 'startupTasks.webviewUnavailable.windowsContent'
                      : (Platform.isMacOS
                          ? 'startupTasks.webviewUnavailable.macOSContent'
                          : 'startupTasks.webviewUnavailable.linuxContent')),
                  actions: [
                    if (!Platform.isMacOS)
                      TextButton(
                          child: I18nText('startupTasks.webviewUnavailable.exit'),
                          onPressed: () {
                            SystemNavigator.pop();
                          }),
                    if (Platform.isWindows)
                      TextButton(
                          child: I18nText('startupTasks.webviewUnavailable.windowsInstall'),
                          onPressed: () async {
                            await launchUrl(
                                Uri.parse('https://developer.microsoft.com/en-us/microsoft-edge/webview2/#download-section'));
                          }),
                    if (Platform.isMacOS)
                      TextButton(
                          child: I18nText('generic.confirm'),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                  ]));
    }
  }

  static Future<void> downloadVersionManifest(BuildContext context) async {
    VersionManifestProvider manifest = Provider.of<VersionManifestProvider>(context, listen: false);
    await manifest.init(context);
  }

  static Future<void> downloadJava(BuildContext context) async {
    await JavaUtils.downloadJava(context);
  }
}
