import 'package:flutter/material.dart';
import 'package:pencil/data/pencil/host.dart';
import 'package:pencil/data/pencil/task/task.dart';
import 'package:pencil/data/pencil/task/tasks_provider.dart';

abstract class Addon {
  Future<List<String>> listAvailableAddonVersions(BuildContext context, String version, Host host);

  Future<void> downloadAddonManifest(
      BuildContext context, String version, String addonVersion, Host host, Task task, TasksProvider tasks);

  Future<void> downloadClient(
      BuildContext context, String version, String addonVersion, Host host, Task task, TasksProvider tasks);

  Future<void> downloadLibraries(
      BuildContext context, String version, String addonVersion, Host host, Task task, TasksProvider tasks);

  Future<List<String>> modClasspath(BuildContext context, String version, String addonVersion, Host host);

  Future<List<String>> modGameArguments(BuildContext context, String version, String addonVersion, Host host);

  Future<List<String>> modJVMArguments(BuildContext context, String version, String addonVersion, Host host);

  Future<String> modMainClass(BuildContext context, String version, String addonVersion, Host host);

  String get name;
}
