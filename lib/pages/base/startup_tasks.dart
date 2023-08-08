import 'dart:async';
import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            .refreshAccounts(Provider.of<TasksProvider>(context, listen: false))) &&
        context.mounted) {
      ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
          .showSnackBar(const SnackBar(content: Text('Failed to re-authenticate some accounts')));
    }
  }

  static Future<void> checkWebviewAvailability(BuildContext context) async {
    if (!(await WebviewWindow.isWebviewAvailable()) && context.mounted) {
      showDialog(
          context: kBaseNavigatorKey.currentContext!,
          barrierDismissible: Platform.isMacOS,
          builder: (context) => AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                  title: Text(Platform.isMacOS ? 'Embedded Browser Issue' : 'Components Required'),
                  content: Text(Platform.isWindows
                      ? 'To continue, you must install the WebView2 Runtime on your system. You will need to download the "Evergreen" versions. Please restart Pencil after installing.'
                      : (Platform.isMacOS
                          ? 'The embedded browser cannot be initialized on your system. You might not be able to log in.'
                          : 'To continue, you must install webkit2gtk on your system. Please restart Pencil after installing.')),
                  actions: [
                    if (!Platform.isMacOS)
                      TextButton(
                          child: const Text('Exit'),
                          onPressed: () {
                            SystemNavigator.pop();
                          }),
                    if (Platform.isWindows)
                      TextButton(
                          child: const Text('Install'),
                          onPressed: () async {
                            await launchUrl(
                                Uri.parse('https://developer.microsoft.com/en-us/microsoft-edge/webview2/#download-section'));
                          }),
                    if (Platform.isMacOS)
                      TextButton(
                          child: const Text('Confirm'),
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
