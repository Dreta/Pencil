import 'package:flutter/material.dart';
import 'package:pencil/data/host.dart';
import 'package:pencil/data/task/task.dart';
import 'package:pencil/data/task/tasks_provider.dart';
import 'package:pencil/data/versions/version/version.dart';

abstract class Addon {
  Future<List<String>> listAvailableAddonVersions(BuildContext context, Version version, Host host);

  Future<void> downloadAddonManifest(BuildContext context, Version version, String addonVersion, Host host, Task task, TasksProvider tasks);

  Future<void> downloadClient(BuildContext context, Version version, String addonVersion, Host host, Task task, TasksProvider tasks);

  Future<void> downloadLibraries(BuildContext context, Version version, String addonVersion, Host host, Task task, TasksProvider tasks);

  Future<List<String>> modClasspath(BuildContext context, Version version, String addonVersion, Host host);

  Future<String> modMainClass(BuildContext context, Version version, String addonVersion, Host host);
}
