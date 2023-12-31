import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:path/path.dart' as path;
import 'package:pencil/constants.dart';
import 'package:pencil/data/pencil/account/account.dart';
import 'package:pencil/data/pencil/host.dart';
import 'package:pencil/data/pencil/profile/profile.dart';
import 'package:pencil/data/pencil/profile/profiles_provider.dart';
import 'package:pencil/data/pencil/settings/settings_provider.dart';
import 'package:pencil/data/pencil/task/task.dart';
import 'package:pencil/data/pencil/task/tasks_provider.dart';
import 'package:pencil/data/minecraft/rule.dart';
import 'package:pencil/data/minecraft/version/arguments.dart';
import 'package:pencil/data/minecraft/version/library.dart';
import 'package:pencil/data/minecraft/version/version.dart';
import 'package:pencil/launch/download_utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

abstract class LaunchUtils {
  static Future<void> _initProfile(BuildContext context, Profile profile) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    String basePath = path.join(settings.data.launcher!.profilesDirectory!, profile.uuid.toString());
    await Directory(path.join(basePath, 'saves')).create(recursive: true);
    await Directory(path.join(basePath, 'resourcepacks')).create(recursive: true);
    await Directory(path.join(basePath, 'screenshots')).create(recursive: true);
    await Directory(path.join(basePath, 'mods')).create(recursive: true);
    await Directory(path.join(basePath, 'shaderpacks')).create(recursive: true);
    await Directory(path.join(basePath, 'texturepacks')).create(recursive: true);
    await Directory(path.join(basePath, 'logs')).create(recursive: true);
    await Directory(path.join(basePath, 'crash-reports')).create(recursive: true);
    await Directory(path.join(basePath, 'config')).create(recursive: true);
  }

  static Future<String?> _checkLaunchReady(BuildContext context, Profile profile) async {
    TasksProvider tasks = Provider.of<TasksProvider>(context, listen: false);
    if (tasks.tasks.containsKey(TaskType.javaDownload) && tasks.tasks[TaskType.javaDownload]!.isNotEmpty) {
      return FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'launch.notReady.java');
    }
    if (tasks.tasks.containsKey(TaskType.gameDownload) && tasks.tasks[TaskType.gameDownload]!.isNotEmpty) {
      return FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'launch.notReady.downloading');
    }
    return null;
  }

  static Future<String> _processArgument(BuildContext context, Profile profile, Account account, Version version, String argument,
      String nativeDirectory, String classpath) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    return argument
        .replaceAll('\${natives_directory}', nativeDirectory)
        .replaceAll('\${launcher_name}', 'Pencil')
        .replaceAll('\${launcher_version}', 'stable')
        .replaceAll('\${classpath}', classpath)
        .replaceAll('\${clientid}', 'null')
        .replaceAll('\${auth_xuid}', account.xuid ?? '0')
        .replaceAll('\${auth_player_name}', account.characterName)
        .replaceAll('\${version_name}', profile.version)
        .replaceAll('\${game_directory}', path.join(settings.data.launcher!.profilesDirectory!, profile.uuid.toString()))
        .replaceAll('\${assets_root}', settings.data.game!.assetsDirectory!)
        .replaceAll('\${assets_index_name}', version.assetIndex.id)
        .replaceAll('\${auth_uuid}', account.uuid)
        .replaceAll('\${auth_access_token}', account.accessToken)
        .replaceAll('\${user_type}', account.type == AccountType.microsoft ? 'msa' : 'mojang')
        .replaceAll('\${version_type}', version.type.toString().replaceAll('VersionType.', ''))
        .replaceAll('\${resolution_width}', (profile.resolutionWidth ?? 0).toString())
        .replaceAll('\${resolution_height}', (profile.resolutionHeight ?? 0).toString())
        .replaceAll('\${auth_session}', '0')
        .replaceAll('\${user_properties}', '{}')
        .replaceAll('\${game_assets}', settings.data.game!.assetsDirectory!)
        .replaceAll('\${quickPlayPath}', 'quickplay/log.json')
        .replaceAll('\${quickPlaySingleplayer}', profile.quickPlayHost ?? '')
        .replaceAll('\${quickPlayMultiplayer}', profile.quickPlayHost ?? '')
        .replaceAll('\${quickPlayRealms}', profile.quickPlayHost ?? '');
  }

  static Future<String> _initializeNatives(
      BuildContext context, Profile profile, Version version, Task task, TasksProvider tasks) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);

    Directory tempDir = Directory.systemTemp;
    // Clear previous temporary directories, if any
    await for (FileSystemEntity fileDir in tempDir.list()) {
      List<String> pathParts = path.split(fileDir.path);
      if (pathParts[pathParts.length - 1].contains('pencil-natives')) {
        await fileDir.delete(recursive: true);
      }
    }

    Directory nativeDir = Directory(path.join(tempDir.absolute.path, 'pencil-natives-${const Uuid().v4().split('-')[0]}'));
    await nativeDir.create(recursive: true);

    List<Library> toUse = [];
    Map<String, String> nativeNames = {};
    String arch = await OS.getArchitecture();
    for (Library library in version.libraries) {
      bool doUse = false;
      if (library.rules == null || library.rules!.isEmpty) {
        doUse = true;
      } else {
        for (Rule rule in library.rules!) {
          if (await rule.matches(profile)) {
            doUse = rule.action == 'allow';
          }
        }
      }
      if (doUse) {
        // Determine the native to use for libraries with legacy native format (classifiers)
        if (library.natives != null) {
          String? nativeName = library.natives![DownloadUtils.getOSName()]
              ?.replaceAll('\${arch}', (arch == 'x86' ? '32' : ((arch == 'x86_64' || arch == 'x64') ? '64' : 'arm')));
          if (nativeName != null) {
            nativeNames[library.name] = nativeName;
          }
        }
        toUse.add(library);
      }
    }

    List<String> toExtract = [];
    for (Library library in toUse) {
      if (library.downloads.artifact != null && library.name.contains('native')) {
        toExtract.add(path.joinAll([settings.data.game!.librariesDirectory!, ...library.downloads.artifact!.path.split('/')]));
      }
      if (nativeNames.containsKey(library.name) &&
          library.downloads.classifiers != null &&
          library.downloads.classifiers!.containsKey(nativeNames[library.name])) {
        toExtract.add(path.joinAll([
          settings.data.game!.librariesDirectory!,
          ...library.downloads.classifiers![nativeNames[library.name]]!.path.split('/')
        ]));
      }
    }

    Completer<String> completer = Completer<String>();

    (() async {
      ReceivePort receivePort = ReceivePort();
      Isolate.spawn(_extractIsolate, [receivePort.sendPort, toExtract, nativeDir.path]);
      await for (dynamic msg in receivePort) {
        if (msg['type'] == 'progress') {
          task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'launch.nativeExtractFile', translationParams: {'file': msg['progress']});
          tasks.notify();
        }
        if (msg['type'] == 'complete') {
          completer.complete(nativeDir.path);
        }
        if (msg['type'] == 'error') {
          completer.completeError(msg['error']);
        }
      }
    })();

    return completer.future;
  }

  static Future<void> _extractIsolate(List<dynamic> msg) async {
    SendPort sendPort = msg[0];
    List<String> toExtract = msg[1];
    Directory nativeDir = Directory(msg[2]);

    try {
      for (String native in toExtract) {
        List<String> pathParts = path.split(native);
        sendPort.send({'type': 'progress', 'progress': pathParts[pathParts.length - 1]});
        Archive archive = ZipDecoder().decodeBytes(await File(native).readAsBytes());
        for (ArchiveFile file in archive) {
          String filename = file.name;
          if (!filename.toLowerCase().endsWith('.so') &&
              !filename.toLowerCase().endsWith('.dylib') &&
              !filename.toLowerCase().endsWith('.dll')) {
            continue;
          }
          if (file.isFile) {
            if (filename.contains('../') || filename.contains('..\\')) {
              continue;
            }
            List<int> data = file.content;
            File extracted = File(path.joinAll([nativeDir.path, filename.split(Platform.pathSeparator).last]));
            await extracted.create(recursive: true);
            await extracted.writeAsBytes(data);
          }
        }
      }
      sendPort.send({'type': 'complete'});
    } catch (e) {
      sendPort.send({'type': 'error', 'error': e.toString()});
    }
  }

  static String _javaExecutableForPlatform(String javaHome) {
    if (Platform.isLinux) {
      return path.join(javaHome, 'bin', 'java');
    } else if (Platform.isWindows) {
      return path.join(javaHome, 'bin', 'javaw.exe');
    } else if (Platform.isMacOS) {
      return path.join(javaHome, 'Contents', 'Home', 'bin', 'java');
    }
    throw Exception('Unsupported Platform');
  }

  static Future<String> _buildClasspath(BuildContext context, Profile profile, Host host, Version version) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    List<String> parts = [];

    for (Library library in version.libraries) {
      bool doUse = false;
      if (library.rules == null || library.rules!.isEmpty) {
        doUse = true;
      } else {
        for (Rule rule in library.rules!) {
          if (await rule.matches(profile)) {
            doUse = rule.action == 'allow';
          }
        }
      }
      if (doUse) {
        // Do not add natives to classpath
        if (library.downloads.artifact == null) {
          continue;
        }
        if (library.downloads.artifact!.path.contains('native')) {
          continue;
        }
        if (library.natives != null) {
          continue;
        }
        parts.add(path.joinAll([settings.data.game!.librariesDirectory!, ...library.downloads.artifact!.path.split('/')]));
      }
    }
    parts.add(path.join(settings.data.game!.versionsDirectory!, version.id, '${version.id}.jar'));

    if (profile.addon != null) {
      parts.addAll(await profile.addon!.modClasspath(context, version.id, profile.addonVersion!, host));
    }

    return parts.join(':');
  }

  static Future<void> launchGame(BuildContext context, Profile profile, Account account) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    TasksProvider tasks = Provider.of<TasksProvider>(context, listen: false);
    ProfilesProvider profiles = Provider.of<ProfilesProvider>(context, listen: false);

    profiles.isRunning = true;
    profiles.notify();

    try {
      Task task = Task(name: FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'launch.mainTaskName', translationParams: {'version': profile.version}), type: TaskType.gameLaunch);
      tasks.addTask(task);

      String? launchReady = await _checkLaunchReady(context, profile);
      if (launchReady != null) {
        tasks.removeTask(task);
        ScaffoldMessenger.of(kBaseScaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(launchReady)));
        return;
      }

      task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'launch.initProfileDir');
      tasks.notify();
      await _initProfile(context, profile);

      List<String> gameArguments = [];
      List<String> jvmArguments = [];

      task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'launch.readVersion');
      tasks.notify();
      File versionFile = File(path.join(settings.data.game!.versionsDirectory!, profile.version, '${profile.version}.json'));
      Version version = Version.fromJson(jsonDecode(await versionFile.readAsString()));

      task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'launch.extractingNatives');
      tasks.notify();
      String nativeDirectory = await _initializeNatives(context, profile, version, task, tasks);

      task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'launch.classpath');
      tasks.notify();
      String classpath = await _buildClasspath(context, profile, settings.data.launcher!.host!, version);

      task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'launch.arguments');
      tasks.notify();
      if (version.arguments != null) {
        for (dynamic argument in version.arguments!.game) {
          if (argument is String) {
            gameArguments.add(await _processArgument(context, profile, account, version, argument, nativeDirectory, classpath));
          } else if (argument is Map) {
            PlatformArgument platformArg = PlatformArgument.fromJson(argument as Map<String, dynamic>);
            bool doUse = false;
            if (platformArg.rules.isEmpty) {
              doUse = true;
            } else {
              for (Rule rule in platformArg.rules) {
                if (await rule.matches(profile)) {
                  doUse = rule.action == 'allow';
                }
              }
            }
            if (doUse) {
              if (platformArg.value is List) {
                for (String value in (platformArg.value as List<dynamic>)) {
                  gameArguments
                      .add(await _processArgument(context, profile, account, version, value, nativeDirectory, classpath));
                }
              } else if (platformArg.value is String) {
                gameArguments.add(
                    await _processArgument(context, profile, account, version, platformArg.value, nativeDirectory, classpath));
              }
            }
          }
        }

        for (dynamic argument in version.arguments!.jvm) {
          if (argument is String) {
            jvmArguments.add(await _processArgument(context, profile, account, version, argument, nativeDirectory, classpath));
          } else if (argument is Map) {
            PlatformArgument platformArg = PlatformArgument.fromJson(argument as Map<String, dynamic>);
            bool doUse = false;
            if (platformArg.rules.isEmpty) {
              doUse = true;
            } else {
              for (Rule rule in platformArg.rules) {
                if (await rule.matches(profile)) {
                  doUse = rule.action == 'allow';
                }
              }
            }
            if (doUse) {
              if (platformArg.value is List) {
                for (String value in (platformArg.value as List<dynamic>)) {
                  jvmArguments.add(await _processArgument(context, profile, account, version, value, nativeDirectory, classpath));
                }
              } else if (platformArg.value is String) {
                jvmArguments.add(
                    await _processArgument(context, profile, account, version, platformArg.value, nativeDirectory, classpath));
              }
            }
          }
        }
      } else if (version.minecraftArguments != null) {
        for (String argument in version.minecraftArguments!.split(' ')) {
          gameArguments.add(await _processArgument(context, profile, account, version, argument, nativeDirectory, classpath));
        }
        jvmArguments.addAll([
          '-cp',
          classpath,
          '-Djava.library.path=$nativeDirectory',
          '-Djna.tmpdir=$nativeDirectory',
          '-Dorg.lwjgl.system.SharedLibraryExtractPath=$nativeDirectory',
          '-Dio.netty.native.workdir=$nativeDirectory',
          '-Dminecraft.launcher.brand=Pencil',
          '-Dminecraft.launcher.version=stable',
          '-Dminecraft.client.jar=${path.join(settings.data.game!.versionsDirectory!, version.id, '${version.id}.jar')}',
        ]);
        if (Platform.isWindows) {
          jvmArguments.add('-XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe.heapdump');
        }
        if (Platform.isMacOS) {
          jvmArguments.add('-XstartOnFirstThread');
        }
      }
      jvmArguments.add('-Dminecraft.pencil=true');

      if (version.logging != null) {
        jvmArguments.add(version.logging!.client.argument.replaceAll(
            '\${path}', path.join(settings.data.game!.assetsDirectory!, 'log_configs', version.logging!.client.file.id)));
      }
      jvmArguments.addAll(profile.jvmArguments.split(' '));
      gameArguments.addAll(profile.gameArguments.split(' '));

      if (profile.addon != null) {
        gameArguments.addAll(await profile.addon!.modGameArguments(context, version.id, profile.addonVersion!, settings.data.launcher!.host!));
        jvmArguments.addAll(await profile.addon!.modJVMArguments(context, version.id, profile.addonVersion!, settings.data.launcher!.host!));
      }

      task.currentWork = FlutterI18n.translate(kBaseNavigatorKey.currentContext!, 'launch.launching');
      tasks.notify();

      String? javaExecutable;
      String? javaHome;
      if (version.releaseTime == null) {
        javaExecutable = _javaExecutableForPlatform(settings.data.java!.legacyJavaHome!);
        javaHome = settings.data.java!.legacyJavaHome!;
      } else if (version.releaseTime!.isAfter(DateTime(2021, 5, 12))) {
        javaExecutable = _javaExecutableForPlatform(settings.data.java!.modernJavaHome!);
        javaHome = settings.data.java!.modernJavaHome!;
      } else {
        javaExecutable = _javaExecutableForPlatform(settings.data.java!.legacyJavaHome!);
        javaHome = settings.data.java!.legacyJavaHome!;
      }

      String mainClass = profile.addon == null
          ? version.mainClass
          : (await profile.addon!.modMainClass(context, version.id, profile.addonVersion!, settings.data.launcher!.host!));

      Map<String, String> environment = {
        'JAVA_HOME': Platform.isMacOS ? path.join(javaHome, 'Contents', 'Home') : javaHome,
        'MINECRAFT_LAUNCHER': 'Dreta/pencil',
        'USING_PENCIL': 'true'
      };

      for (String entry in profile.environment.split(' ')) {
        if (entry.contains('=')) {
          int sep = entry.indexOf('=');
          environment[entry.substring(0, sep)] = entry.substring(sep + 1);
        }
      }

      Process process = await Process.start(javaExecutable, [...jvmArguments, mainClass, ...gameArguments],
          workingDirectory: path.join(settings.data.launcher!.profilesDirectory!, profile.uuid.toString()),
          environment: environment);
      process.stdout.transform(utf8.decoder).forEach(print);

      if (settings.data.launcher!.hideLauncherAfterStart!) {
        appWindow.hide();
      }

      tasks.removeTask(task);
      int exitCode = await process.exitCode;
      if (exitCode != 0) {
        showDialog(
            context: kBaseNavigatorKey.currentContext!,
            builder: (context) => AlertDialog(
                    insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                    title: I18nText('launch.crash.title'),
                    content: I18nText('launch.crash.content', translationParams: {'exitCode': exitCode.toString()}),
                    actions: [
                      TextButton(
                          child: I18nText('generic.confirm'),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ]));
      }

      if (settings.data.launcher!.hideLauncherAfterStart!) {
        appWindow.show();
      }
    } finally {
      profiles.isRunning = false;
      profiles.notify();
    }
  }
}
