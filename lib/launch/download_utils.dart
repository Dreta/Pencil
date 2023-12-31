import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:pencil/constants.dart';
import 'package:pencil/data/pencil/host.dart';
import 'package:pencil/data/pencil/profile/profile.dart';
import 'package:pencil/data/pencil/profile/profiles_provider.dart';
import 'package:pencil/data/pencil/settings/settings_provider.dart';
import 'package:pencil/data/pencil/task/task.dart';
import 'package:pencil/data/pencil/task/tasks_provider.dart';
import 'package:pencil/data/minecraft/assets/asset.dart';
import 'package:pencil/data/minecraft/assets/assets.dart';
import 'package:pencil/data/minecraft/manifest/manifest_version.dart';
import 'package:pencil/data/minecraft/manifest/version_manifest.dart';
import 'package:pencil/data/minecraft/manifest/version_manifest_provider.dart';
import 'package:pencil/data/minecraft/rule.dart';
import 'package:pencil/data/minecraft/version/library.dart';
import 'package:pencil/data/minecraft/version/version.dart';
import 'package:provider/provider.dart';

abstract class DownloadUtils {
  static Future<bool> downloadProfile(BuildContext context, Profile profile) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context, listen: false);
    TasksProvider tasks = Provider.of<TasksProvider>(context, listen: false);
    VersionManifestProvider manifest = Provider.of<VersionManifestProvider>(context, listen: false);

    if (manifest.manifest == null && context.mounted) {
      ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: I18nText('download.errorVersionManifestUnavailable')));
      return false;
    }

    Task task = Task(
        name: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.mainTaskName', translationParams: {'version': profile.version}), type: TaskType.gameDownload, currentWork: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.begin'));
    tasks.addTask(task);
    Host host = settings.data.launcher!.host!;
    try {
      http.Client client = http.Client();
      Version version = await _downloadVersion(
          context,
          client,
          profile.version,
          host,
          manifest.manifest!,
          tasks,
          task);
      Assets assets = await _downloadAssetIndex(context, client, version, host, tasks, task);
      await _downloadLoggingConfig(context, client, version, host, tasks, task);
      await _downloadAssets(
          context,
          client,
          assets,
          version.assetIndex.totalSize,
          host,
          tasks,
          task);
      await _downloadLibraries(
          context,
          client,
          version,
          profile,
          host,
          tasks,
          task);
      await _downloadAddon(context, version, profile, host, tasks, task);
      await _downloadGame(context, client, version, host, task, tasks);

      profile.lastDownloaded = DateTime.now();
      profiles.save();
      return true;
    } catch (e) {
      showDialog(
          context: kBaseNavigatorKey.currentContext!,
          builder: (context) => AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                  title: I18nText('download.errorGeneric', translationParams: {'version': profile.version}),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                        child: I18nText('generic.confirm'),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ]));
    } finally {
      tasks.removeTask(task);
    }
    return false;
  }

  static Future<Version> _downloadVersion(BuildContext context, http.Client client, String version, Host host,
      VersionManifest manifest, TasksProvider tasks, Task task) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    File file = File(path.join(settings.data.game!.versionsDirectory!, version, '$version.json'));
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }

    task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.metadata.work', translationParams: {'version': version});
    task.progress = -1;
    tasks.notify();

    ManifestVersion? mfVersion;
    for (ManifestVersion v in manifest.versions) {
      if (v.id == version) {
        mfVersion = v;
        break;
      }
    }
    if (mfVersion == null) {
      throw Exception(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.errorInvalidVersion', translationParams: {'version': version}));
    }

    Uint8List fileBytes = await file.readAsBytes();
    if (mfVersion.sha1 != null && sha1.convert(fileBytes).toString() == mfVersion.sha1) {
      return Version.fromJson(jsonDecode(utf8.decode(fileBytes)));
    }

    http.Response r = await client.get(Uri.parse(host.formatLink(mfVersion.url)), headers: {'User-Agent': kUserAgent});
    if (mfVersion.sha1 != null && sha1.convert(r.bodyBytes).toString() != mfVersion.sha1) {
      throw Exception(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.metadata.errorChecksum', translationParams: {'version': version}));
    }

    await file.writeAsBytes(r.bodyBytes);
    return Version.fromJson(jsonDecode(utf8.decode(r.bodyBytes)));
  }

  static Future<Assets> _downloadAssetIndex(
      BuildContext context, http.Client client, Version version, Host host, TasksProvider tasks, Task task) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    File file = File(path.join(settings.data.game!.assetsDirectory!, 'indexes', '${version.assetIndex.id}.json'));
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }

    task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.assetIndex.work', translationParams: {'assetIndex': version.assetIndex.id});
    task.progress = -1;
    tasks.notify();

    Uint8List fileBytes = await file.readAsBytes();
    if (fileBytes.lengthInBytes == version.assetIndex.size && sha1.convert(fileBytes).toString() == version.assetIndex.sha1) {
      return Assets.fromJson(jsonDecode(utf8.decode(fileBytes)));
    }

    http.Response r = await client.get(Uri.parse(host.formatLink(version.assetIndex.url)), headers: {'User-Agent': kUserAgent});
    if (version.assetIndex.sha1 != sha1.convert(r.bodyBytes).toString()) {
      throw Exception(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.assetIndex.errorChecksum', translationParams: {'assetIndex': version.assetIndex.id}));
    }
    if (version.assetIndex.size != r.bodyBytes.lengthInBytes) {
      throw Exception(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.assetIndex.errorSize', translationParams: {'assetIndex': version.assetIndex.id}));
    }
    await file.writeAsBytes(r.bodyBytes);
    return Assets.fromJson(jsonDecode(utf8.decode(r.bodyBytes)));
  }

  static Future<void> _downloadAssets(
      BuildContext context, http.Client client, Assets assets, int totalSize, Host host, TasksProvider tasks, Task task) async {
    task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.asset.begin');
    task.progress = 0;
    tasks.notify();
    await _downloadAsset(context, client, host, assets.objects.entries.toList(), 0, totalSize, 0, tasks, task);
  }

  static Future<void> _downloadAsset(BuildContext context, http.Client client, Host host, List<MapEntry<String, Asset>> assets,
      int totalDownloaded, int totalSize, int current, TasksProvider tasks, Task task) async {
    if (current >= assets.length) {
      return;
    }

    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    MapEntry<String, Asset> asset = assets[current];
    task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.asset.work', translationParams: {'asset': asset.key});
    tasks.notify();

    File file =
        File(path.join(settings.data.game!.assetsDirectory!, 'objects', asset.value.hash.substring(0, 2), asset.value.hash));
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }
    Uint8List fileBytes = await file.readAsBytes();
    if (fileBytes.lengthInBytes == (asset.value.size ?? fileBytes.lengthInBytes) &&
        sha1.convert(fileBytes).toString() == asset.value.hash) {
      totalDownloaded += fileBytes.lengthInBytes;
      task.progress = min(totalDownloaded / totalSize, 1);
      tasks.notify();
      return await _downloadAsset(context, client, host, assets, totalDownloaded, totalSize, current + 1, tasks, task);
    }

    Completer<void> completer = Completer<void>();
    http.Request request = http.Request(
      'GET',
      Uri.parse(
          host.formatLink('https://resources.download.minecraft.net/${asset.value.hash.substring(0, 2)}/${asset.value.hash}')),
    )..headers['User-Agent'] = kUserAgent;
    http.StreamedResponse r = await client.send(request);

    List<int> bodyBytes = [];
    r.stream.listen((value) {
      bodyBytes.addAll(value);
      totalDownloaded += value.length;
      task.progress = min(totalDownloaded / totalSize, 1);
      tasks.notify();
    })
      ..onError((e) {
        completer.completeError(e);
      })
      ..onDone(() async {
        if (asset.value.hash != sha1.convert(bodyBytes).toString()) {
          completer.completeError(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.asset.errorChecksum', translationParams: {'asset': asset.key}));
          return;
        }
        if (asset.value.size != null && asset.value.size != bodyBytes.length) {
          completer.completeError(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.asset.errorSize', translationParams: {'asset': asset.key}));
          return;
        }
        await file.writeAsBytes(bodyBytes);
        await _downloadAsset(context, client, host, assets, totalDownloaded, totalSize, current + 1, tasks, task);
        completer.complete();
      });
    return completer.future;
  }

  static Future<void> _downloadLoggingConfig(
      BuildContext context, http.Client client, Version version, Host host, TasksProvider tasks, Task task) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);

    if (version.logging == null) {
      return;
    }

    task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.loggingConfig', translationParams: {'loggingConfig': version.logging!.client.file.id});
    task.progress = -1;
    tasks.notify();

    File file = File(path.join(settings.data.game!.assetsDirectory!, 'log_configs', version.logging!.client.file.id));
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }
    Uint8List fileBytes = await file.readAsBytes();
    if (fileBytes.lengthInBytes == (version.logging!.client.file.size ?? fileBytes.lengthInBytes) &&
        sha1.convert(fileBytes).toString() == (version.logging!.client.file.sha1 ?? sha1.convert(fileBytes).toString())) {
      return;
    }

    http.Response r =
        await client.get(Uri.parse(host.formatLink(version.logging!.client.file.url)), headers: {'User-Agent': kUserAgent});
    if (version.logging!.client.file.sha1 != null && version.logging!.client.file.sha1 != sha1.convert(r.bodyBytes).toString()) {
      throw Exception(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.loggingConfig.errorChecksum', translationParams: {'loggingConfig': version.logging!.client.file.id}));
    }
    if (version.logging!.client.file.size != null && version.logging!.client.file.size != r.bodyBytes.lengthInBytes) {
      throw Exception(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.loggingConfig.errorSize', translationParams: {'loggingConfig': version.logging!.client.file.id}));
    }
    await file.writeAsBytes(r.bodyBytes);
  }

  static Future<void> _downloadAddon(
      BuildContext context, Version version, Profile profile, Host host, TasksProvider tasks, Task task) async {
    if (profile.addon == null) {
      return;
    }
    await profile.addon!.downloadAddonManifest(context, version.id, profile.addonVersion!, host, task, tasks);
    await profile.addon!.downloadLibraries(context, version.id, profile.addonVersion!, host, task, tasks);
    await profile.addon!.downloadClient(context, version.id, profile.addonVersion!, host, task, tasks);
  }

  static Future<void> _downloadLibraries(BuildContext context, http.Client client, Version version, Profile profile, Host host,
      TasksProvider tasks, Task task) async {
    String arch = await OS.getArchitecture();

    task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.libraries.begin');
    task.progress = 0;
    tasks.notify();

    int totalSize = 0;

    // Compile list of libraries that matches rules
    List<Library> toDownload = [];
    Map<String, String> nativeNames = {};
    for (Library library in version.libraries) {
      bool doDownload = false;
      if (library.rules == null || library.rules!.isEmpty) {
        doDownload = true;
      } else {
        for (Rule rule in library.rules!) {
          if (await rule.matches(profile)) {
            doDownload = rule.action == 'allow';
          }
        }
      }
      if (doDownload) {
        totalSize += library.downloads.artifact?.size ?? 0;
        // Determine the native to use for libraries with legacy native format (classifiers)
        if (library.natives != null) {
          String? nativeName = library.natives![getOSName()]
              ?.replaceAll('\${arch}', (arch == 'x86' ? '32' : ((arch == 'x86_64' || arch == 'x64') ? '64' : 'arm')));
          if (nativeName != null) {
            nativeNames[library.name] = nativeName;
            totalSize += library.downloads.classifiers![nativeName]!.size ?? 0;
          }
        }
        toDownload.add(library);
      }
    }

    if (totalSize == 0) {
      totalSize++; // Prevent division by zero
    }

    await _downloadLibrary(context, client, host, toDownload, nativeNames, 0, 0, totalSize, task, tasks);
  }

  static Future<void> _downloadLibrary(BuildContext context, http.Client client, Host host, List<Library> libraries,
      Map<String, String> nativeNames, int current, int totalDownloaded, int totalSize, Task task, TasksProvider tasks) async {
    if (current >= libraries.length) {
      return;
    }

    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    Library library = libraries[current];
    Completer<void> completer = Completer<void>();

    task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.library.work', translationParams: {'library': library.name});
    tasks.notify();

    // Download main artifact, if any (This can be a native in newer versions of the game)
    if (library.downloads.artifact != null) {
      List<String> pathParts = [settings.data.game!.librariesDirectory!];
      pathParts.addAll(library.downloads.artifact!.path.split('/'));
      File aFile = File(path.joinAll(pathParts));
      if (!(await aFile.exists())) {
        await aFile.create(recursive: true);
      }
      Uint8List aFileBytes = await aFile.readAsBytes();
      bool isValid = true;
      if (library.downloads.artifact!.sha1 != null && library.downloads.artifact!.sha1 != sha1.convert(aFileBytes).toString()) {
        isValid = false;
      }
      if (library.downloads.artifact!.size != null && library.downloads.artifact!.size != aFileBytes.lengthInBytes) {
        isValid = false;
      }
      if (!isValid) {
        task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.library.main.work', translationParams: {'library': library.name});
        tasks.notify();

        http.Request request = http.Request('GET', Uri.parse(host.formatLink(library.downloads.artifact!.url)))
          ..headers['User-Agent'] = kUserAgent;
        http.StreamedResponse r = await client.send(request);

        List<int> bodyBytes = [];
        r.stream.listen((value) {
          bodyBytes.addAll(value);
          totalDownloaded += value.length;
          task.progress = min(totalDownloaded / totalSize, 1);
          tasks.notify();
        })
          ..onError((e) {
            completer.completeError(e);
          })
          ..onDone(() async {
            if (library.downloads.artifact!.sha1 != null &&
                library.downloads.artifact!.sha1 != sha1.convert(bodyBytes).toString()) {
              completer.completeError(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.library.main.errorChecksum', translationParams: {'library': library.name}));
              return;
            }
            if (library.downloads.artifact!.size != null && library.downloads.artifact!.size != bodyBytes.length) {
              completer.completeError(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.library.main.errorSize', translationParams: {'library': library.name}));
              return;
            }
            await aFile.writeAsBytes(bodyBytes);
            if (!nativeNames.containsKey(library.name) ||
                library.downloads.classifiers == null ||
                !library.downloads.classifiers!.containsKey(nativeNames[library.name]!)) {
              await _downloadLibrary(
                  context, client, host, libraries, nativeNames, current + 1, totalDownloaded, totalSize, task, tasks);
              completer.complete();
            }
          });
      } else {
        totalDownloaded += aFileBytes.lengthInBytes;
        task.progress = min(totalDownloaded / totalSize, 1);
        tasks.notify();
        if (!nativeNames.containsKey(library.name) ||
            library.downloads.classifiers == null ||
            !library.downloads.classifiers!.containsKey(nativeNames[library.name]!)) {
          return await _downloadLibrary(
              context, client, host, libraries, nativeNames, current + 1, totalDownloaded, totalSize, task, tasks);
        }
      }
    }

    // Download legacy native (classifiers), if any
    if (nativeNames.containsKey(library.name) &&
        library.downloads.classifiers != null &&
        library.downloads.classifiers!.containsKey(nativeNames[library.name])) {
      List<String> pathParts = [settings.data.game!.librariesDirectory!];
      ArtifactDownload native = library.downloads.classifiers![nativeNames[library.name]!]!;
      pathParts.addAll(native.path.split('/'));
      File nFile = File(path.joinAll(pathParts));
      if (!(await nFile.exists())) {
        await nFile.create(recursive: true);
      }
      Uint8List nFileBytes = await nFile.readAsBytes();
      bool isValid = true;
      if (native.sha1 != null && native.sha1 != sha1.convert(nFileBytes).toString()) {
        isValid = false;
      }
      if (native.size != null && native.size != nFileBytes.lengthInBytes) {
        isValid = false;
      }
      if (!isValid) {
        task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.library.native.work', translationParams: {'library': library.name});
        tasks.notify();

        http.Request request = http.Request('GET', Uri.parse(host.formatLink(native.url)))..headers['User-Agent'] = kUserAgent;
        http.StreamedResponse r = await client.send(request);

        List<int> bodyBytes = [];
        r.stream.listen((value) {
          bodyBytes.addAll(value);
          totalDownloaded += value.length;
          task.progress = min(totalDownloaded / totalSize, 1);
          tasks.notify();
        })
          ..onError((e) {
            completer.completeError(e);
          })
          ..onDone(() async {
            if (native.sha1 != null && native.sha1 != sha1.convert(bodyBytes).toString()) {
              completer.completeError(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.library.native.errorChecksum', translationParams: {'library': library.name}));
              return;
            }
            if (native.size != null && native.size != bodyBytes.length) {
              completer.completeError(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.library.native.errorSize', translationParams: {'library': library.name}));
              return;
            }
            await nFile.writeAsBytes(bodyBytes);
            await _downloadLibrary(
                context, client, host, libraries, nativeNames, current + 1, totalDownloaded, totalSize, task, tasks);
            completer.complete();
          });
      } else {
        totalDownloaded += nFileBytes.lengthInBytes;
        task.progress = min(totalDownloaded / totalSize, 1);
        tasks.notify();
        return await _downloadLibrary(
            context, client, host, libraries, nativeNames, current + 1, totalDownloaded, totalSize, task, tasks);
      }
    }

    return completer.future;
  }

  static Future<void> _downloadGame(
      BuildContext context, http.Client client, Version version, Host host, Task task, TasksProvider tasks) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    File file = File(path.join(settings.data.game!.versionsDirectory!, version.id, '${version.id}.jar'));
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }

    task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.client.work', translationParams: {'version': version.id});
    task.progress = 0;
    tasks.notify();

    Uint8List fileBytes = await file.readAsBytes();
    if (fileBytes.lengthInBytes == (version.downloads.client.size ?? fileBytes.lengthInBytes) &&
        sha1.convert(fileBytes) == (version.downloads.client.sha1 ?? sha1.convert(fileBytes))) {
      return;
    }

    http.Request request = http.Request('GET', Uri.parse(host.formatLink(version.downloads.client.url)))
      ..headers['User-Agent'] = kUserAgent;
    http.StreamedResponse r = await client.send(request);

    List<int> bodyBytes = [];
    int received = 0;

    r.stream.listen((value) {
      bodyBytes.addAll(value);
      received += value.length;
      task.progress = min(version.downloads.client.size == null ? -1 : received / version.downloads.client.size!, 1);
      tasks.notify();
    }).onDone(() async {
      if (version.downloads.client.sha1 != null && version.downloads.client.sha1 != sha1.convert(bodyBytes).toString()) {
        throw Exception(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.client.errorChecksum', translationParams: {'version': version.id}));
      }
      if (version.downloads.client.size != null && version.downloads.client.size != bodyBytes.length) {
        throw Exception(FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'download.client.errorSize', translationParams: {'version': version.id}));
      }
      await file.writeAsBytes(bodyBytes);
    });
  }

  static String getOSName() {
    if (Platform.isLinux) {
      return 'linux';
    }
    if (Platform.isWindows) {
      return 'windows';
    }
    if (Platform.isMacOS) {
      return 'osx';
    }
    throw Exception('Unsupported Platform');
  }
}
