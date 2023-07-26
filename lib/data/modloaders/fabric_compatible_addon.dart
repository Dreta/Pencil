import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:pencil/constants.dart';
import 'package:pencil/data/host.dart';
import 'package:pencil/data/modloaders/addon.dart';
import 'package:pencil/data/modloaders/fabric.dart';
import 'package:pencil/data/settings/settings_provider.dart';
import 'package:pencil/data/task/task.dart';
import 'package:pencil/data/task/tasks_provider.dart';
import 'package:pencil/data/versions/version/version.dart';
import 'package:provider/provider.dart';

// Usable for both Fabric and Quilt
class FabricCompatibleAddon extends Addon {
  FabricCompatibleAddon({required this.type});

  final FabricType type;
  Map<String, FabricCompatibleLoader>? _cache;

  @override
  String get name {
    return type == FabricType.fabric ? 'Fabric' : 'Quilt';
  }

  @override
  Future<void> downloadAddonManifest(
      BuildContext context, Version version, String addonVersion, Host host, Task task, TasksProvider tasks) async {
    return;
  }

  @override
  Future<void> downloadLibraries(
      BuildContext context, Version version, String addonVersion, Host host, Task task, TasksProvider tasks) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);

    task.currentWork = 'Beginning to download libraries for Fabric (Quilt)';
    task.progress = -1;
    tasks.notify();

    FabricCompatibleLoader loader = (await getManifest(context, version, host))[addonVersion]!;
    List<FabricLibrary> toDownload = [];
    toDownload.addAll(loader.launcherMeta.libraries.client);
    toDownload.addAll(loader.launcherMeta.libraries.common);

    for (FabricLibrary library in toDownload) {
      task.currentWork = 'Downloading library ${library.name}';
      tasks.notify();

      List<String> nameParts = library.name.split(':');
      List<String> orgParts = nameParts[0].split('.');
      String libraryName = nameParts[1];
      String libraryVer = nameParts[2];

      File file = File(path.joinAll(
          [settings.data.game!.librariesDirectory!, ...orgParts, libraryName, libraryVer, '${libraryName}-${libraryVer}.jar']));
      if (await file.exists()) {
        continue;
      }

      http.Response r = await http.get(
          Uri.parse(host
              .formatLink('${library.url}/${orgParts.join('/')}/${libraryName}/${libraryVer}/${libraryName}-${libraryVer}.jar')),
          headers: {'User-Agent': kUserAgent});
      if (!(await file.exists())) {
        await file.create(recursive: true);
      }
      await file.writeAsBytes(r.bodyBytes);
    }
  }

  @override
  Future<void> downloadClient(
      BuildContext context, Version version, String addonVersion, Host host, Task task, TasksProvider tasks) async {
    task.currentWork = 'Beginning to download Fabric (Quilt) Loader';
    task.progress = -1;
    tasks.notify();

    FabricCompatibleLoader loader = (await getManifest(context, version, host))[addonVersion]!;
    await downloadFabricVersion(context, type, loader.loader, host, task, tasks);
    if (loader.intermediary != null) {
      await downloadFabricVersion(context, type, loader.intermediary!, host, task, tasks);
    }
    if (loader.hashed != null) {
      await downloadFabricVersion(context, type, loader.hashed!, host, task, tasks);
    }
  }

  Future<void> downloadFabricVersion(
      BuildContext context, FabricType type, FabricVersion library, Host host, Task task, TasksProvider tasks) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);

    task.currentWork = 'Downloading library ${library.maven}';
    tasks.notify();

    List<String> nameParts = library.maven.split(':');
    List<String> orgParts = nameParts[0].split('.');
    String libraryName = nameParts[1];
    String libraryVer = nameParts[2];

    File file = File(path.joinAll(
        [settings.data.game!.librariesDirectory!, ...orgParts, libraryName, libraryVer, '${libraryName}-${libraryVer}.jar']));
    if (await file.exists()) {
      return;
    }

    http.Response r = await http.get(
        Uri.parse(host.formatLink(
            '${type.maven(libraryVer.contains('SNAPSHOT'))}/${orgParts.join('/')}/${libraryName}/${libraryVer}/${libraryName}-${libraryVer}.jar')),
        headers: {'User-Agent': kUserAgent});
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }
    await file.writeAsBytes(r.bodyBytes);
  }

  @override
  Future<List<String>> listAvailableAddonVersions(BuildContext context, Version version, Host host) async {
    return (await getManifest(context, version, host)).keys.toList();
  }

  Future<Map<String, FabricCompatibleLoader>> getManifest(BuildContext context, Version version, Host host) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    File file = File(path.join(settings.data.game!.versionsDirectory!, version.id, '${type.name}.json'));

    if (_cache != null) {
      return _cache!;
    }

    try {
      http.Response r =
          await http.get(Uri.parse(host.formatLink('${type.download}${version.id}')), headers: {'User-Agent': kUserAgent});
      Map<String, FabricCompatibleLoader> available = {};
      for (Map<String, dynamic> fv in jsonDecode(utf8.decode(r.bodyBytes))) {
        FabricCompatibleLoader loader = FabricCompatibleLoader.fromJson(fv);
        available[loader.loader.version] = loader;
      }
      if (!(await file.exists())) {
        await file.create(recursive: true);
      }
      await file.writeAsBytes(r.bodyBytes);
      _cache = available;
      return available;
    } catch (e) {
      // Fallback to existing file
      if (await file.exists()) {
        try {
          Map<String, FabricCompatibleLoader> available = {};
          for (Map<String, dynamic> fv in jsonDecode(await file.readAsString())) {
            FabricCompatibleLoader loader = FabricCompatibleLoader.fromJson(fv);
            available[loader.loader.version] = loader;
          }
          _cache = available;
          return available;
        } catch (e2) {
          throw e;
        }
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<List<String>> modClasspath(BuildContext context, Version version, String addonVersion, Host host) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    FabricCompatibleLoader loader = (await getManifest(context, version, host))[addonVersion]!;

    List<String> classpath = [];
    List<FabricLibrary> libraries = [];
    libraries.addAll(loader.launcherMeta.libraries.client);
    libraries.addAll(loader.launcherMeta.libraries.common);
    libraries.add(FabricLibrary(loader.loader.maven, ''));
    if (loader.intermediary != null) {
      libraries.add(FabricLibrary(loader.intermediary!.maven, ''));
    }
    if (loader.hashed != null) {
      libraries.add(FabricLibrary(loader.hashed!.maven, ''));
    }
    for (FabricLibrary library in libraries) {
      List<String> nameParts = library.name.split(':');
      List<String> orgParts = nameParts[0].split('.');
      String libraryName = nameParts[1];
      String libraryVer = nameParts[2];
      classpath.add(path.joinAll([settings.data.game!.librariesDirectory!, ...orgParts, libraryName, libraryVer, '${libraryName}-${libraryVer}.jar']));
    }
    return classpath;
  }

  @override
  Future<String> modMainClass(BuildContext context, Version version, String addonVersion, Host host) async {
    FabricCompatibleLoader loader = (await getManifest(context, version, host))[addonVersion]!;
    return loader.launcherMeta.mainClass.client;
  }
}

enum FabricType {
  fabric,
  quilt;

  String get download {
    return {
      FabricType.fabric: 'https://meta.fabricmc.net/v2/versions/loader/',
      FabricType.quilt: 'https://meta.quiltmc.org/v3/versions/loader/'
    }[this]!;
  }

  String maven(bool isSnapshot) {
    if (this == FabricType.quilt) {
      return isSnapshot ? 'https://maven.quiltmc.org/repository/snapshot/' : 'https://maven.quiltmc.org/repository/release/';
    }
    return 'https://maven.fabricmc.net/';
  }

  String get name {
    return {FabricType.fabric: 'fabric', FabricType.quilt: 'quilt'}[this]!;
  }
}
