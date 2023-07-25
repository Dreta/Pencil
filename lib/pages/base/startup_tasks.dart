import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:pencil/constants.dart';
import 'package:pencil/data/account/accounts_provider.dart';
import 'package:pencil/data/settings/settings_provider.dart';
import 'package:pencil/data/task/task.dart';
import 'package:pencil/data/task/tasks_provider.dart';
import 'package:pencil/data/versions/manifest/version_manifest_provider.dart';
import 'package:pencil/data/versions/rule.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class StartupTasks {
  static Future<void> refreshAccounts(BuildContext context) async {
    if (!(await Provider.of<AccountsProvider>(context, listen: false)
            .refreshAccounts(Provider.of<TasksProvider>(context, listen: false))) &&
        context.mounted) {
      ScaffoldMessenger.of(kBaseKey.currentContext!)
          .showSnackBar(const SnackBar(content: Text('Failed to re-authenticate some accounts')));
    }
  }

  static Future<void> checkWebviewAvailability(BuildContext context) async {
    if (!(await WebviewWindow.isWebviewAvailable()) && context.mounted) {
      showDialog(
          context: context,
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
    TasksProvider tasks = Provider.of<TasksProvider>(context, listen: false);
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);

    if (!settings.data.java!.useManaged!) {
      return;
    }

    String arch = await OS.getArchitecture();
    String? javaArch;
    if (arch == 'x86' || arch == 'arm' || arch == 'aarch64' || arch == 'riscv64') {
      javaArch = arch;
    } else if (arch == 'x86_64' || arch == 'amd64' || arch == 'x64') {
      javaArch = 'x64';
    } else {
      throw Exception('Unsupported Architecture');
    }

    String? javaOS;
    if (Platform.isLinux) {
      File alpineRelease = File('/etc/alpine-release');
      if (await alpineRelease.exists()) {
        javaOS = 'alpine-linux';
      } else {
        javaOS = 'linux';
      }
    } else if (Platform.isWindows) {
      javaOS = 'windows';
    } else if (Platform.isMacOS) {
      javaOS = 'mac';
    } else {
      throw Exception('Unsupported Platform');
    }

    Task task = Task(name: 'Downloading Java', type: TaskType.javaDownload)..progress = 0;
    tasks.addTask(task);

    try {
      Map<String, dynamic>? java17VerInfo = await javaNeedsUpdate(settings.data.java!.modernJavaHome!, '17', javaArch, javaOS);
      if (java17VerInfo != null) {
        await downloadJavaTo(settings.data.java!.modernJavaHome!, java17VerInfo, javaArch, javaOS, task, tasks);
      }
      Map<String, dynamic>? java8VerInfo = await javaNeedsUpdate(settings.data.java!.legacyJavaHome!, '8', javaArch, javaOS);
      if (java8VerInfo != null) {
        await downloadJavaTo(settings.data.java!.legacyJavaHome!, java8VerInfo, javaArch, javaOS, task, tasks);
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                    title: const Text('Failed to download Java'),
                    content: const Text('You won\'t be able to launch the game. Please check your internet connection.'),
                    actions: [
                      TextButton(
                          child: const Text('Confirm'),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ]));
      }
    } finally {
      tasks.removeTask(task);
    }
  }

  static Future<Map<String, dynamic>?> javaNeedsUpdate(String directory, String version, String javaArch, String javaOS) async {
    File javaVersionFile = File(path.join(directory, '.pencil'));
    try {
      http.Response r = await http.get(
          Uri.parse(
              'https://api.adoptium.net/v3/assets/latest/$version/hotspot?architecture=$javaArch&image_type=jre&os=$javaOS&vendor=eclipse'),
          headers: {'User-Agent': kUserAgent});
      Map<String, dynamic> body = jsonDecode(utf8.decode(r.bodyBytes))[0];

      if (!(await javaVersionFile.exists())) {
        return body;
      }
      if ((await javaVersionFile.readAsString()).replaceAll('\n', '') != body['version']['openjdk_version']) {
        return body;
      }
      return null;
    } catch (e) {
      if (await javaVersionFile.exists()) {
        return null;
      }
      return {};
    }
  }

  static Future<void> downloadJavaTo(
      String directory, Map<String, dynamic> verInfo, String javaArch, String javaOS, Task task, TasksProvider tasks) async {
    task.currentWork = 'Downloading JRE ${verInfo['version']['openjdk_version']} ($javaOS on $javaArch)';
    task.progress = 0;
    tasks.notify();
    File tmpZip = File(path.join(directory, '..', 'jre-${verInfo['version']['openjdk_version']}-$javaOS-$javaArch'));
    if (!(await tmpZip.exists())) {
      await tmpZip.create(recursive: true);
    }

    http.Client client = http.Client();
    String sha256Hash = verInfo['binary']['package']['checksum'];

    http.Request downRequest = http.Request('GET', Uri.parse(verInfo['binary']['package']['link']))
      ..headers['User-Agent'] = kUserAgent;
    http.StreamedResponse downResp = await client.send(downRequest);

    int totalSize = verInfo['binary']['package']['size'];
    int totalDownloaded = 0;

    List<int> bodyBytes = [];
    Completer<void> completer = Completer<void>();
    downResp.stream.listen((value) {
      bodyBytes.addAll(value);
      totalDownloaded += value.length;
      task.progress = min(totalDownloaded / totalSize, 1);
      tasks.notify();
    })
      ..onError((e) {
        completer.completeError(e);
      })
      ..onDone(() async {
        if (sha256Hash != sha256.convert(bodyBytes).toString()) {
          completer.completeError('Invalid SHA256 checksum for JRE ${verInfo['version']['openjdk_version']}/$javaOS/$javaArch');
          return;
        }
        task
          ..progress = -1
          ..currentWork = 'Extracting JRE ${verInfo['version']['openjdk_version']} ($javaOS on $javaArch)';
        tasks.notify();

        await tmpZip.writeAsBytes(bodyBytes, flush: true);

        Directory dir = Directory(directory);
        if (await dir.exists()) {
          await dir.delete(recursive: true);
        }
        await dir.create(recursive: true);

        ReceivePort receivePort = ReceivePort();
        String sourcePath = tmpZip.absolute.path;
        String toPath = dir.absolute.path;
        Isolate.spawn(extractIsolate, [
          receivePort.sendPort,
          sourcePath,
          toPath,
          verInfo['version']['openjdk_version'],
          verInfo['binary']['package']['link']
        ]);
        await for (dynamic msg in receivePort) {
          if (msg['type'] == 'complete') {
            completer.complete();
          }
          if (msg['type'] == 'error') {
            completer.completeError(msg['error']);
          }
        }
      });

    return completer.future;
  }

  static Future<void> extractIsolate(List<dynamic> msg) async {
    SendPort sendPort = msg[0];
    String sourcePath = msg[1];
    String toPath = msg[2];
    String version = msg[3];
    String downloadLink = msg[4];

    File tmpZip = File(sourcePath);
    try {
      Archive archive = downloadLink.endsWith('.tar.gz')
          ? TarDecoder().decodeBytes(GZipDecoder().decodeBytes(await tmpZip.readAsBytes()))
          : ZipDecoder().decodeBytes(await tmpZip.readAsBytes());
      for (ArchiveFile file in archive) {
        String filename = file.name;
        if (file.isFile) {
          if (filename.contains('../') || filename.contains('..\\')) {
            continue;
          }
          List<int> data = file.content;
          File extracted = File(path.joinAll([toPath, ...filename.split(Platform.pathSeparator).sublist(1)]));
          await extracted.create(recursive: true);
          await extracted.writeAsBytes(data);
        } else {
          await Directory(path.joinAll([toPath, ...filename.split(Platform.pathSeparator).sublist(1)])).create(recursive: true);
        }
      }
      File versionFile = File(path.join(toPath, '.pencil'));
      if (!(await versionFile.exists())) {
        await versionFile.create(recursive: true);
      }
      await versionFile.writeAsString(version);
      if (Platform.isLinux) {
        await Process.run('chmod', ['+x', path.join(toPath, 'bin', 'java')]);
      }
      if (Platform.isMacOS) {
        await Process.run('chmod', ['+x', path.join(toPath, 'Contents', 'Home', 'bin', 'java')]);
      }
      sendPort.send({'type': 'complete'});
    } catch (e) {
      sendPort.send({'type': 'error', 'error': e.toString()});
    } finally {
      await tmpZip.delete();
    }
  }
}
