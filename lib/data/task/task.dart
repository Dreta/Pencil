import 'package:uuid/uuid.dart';

class Task {
  Task({required this.name, required this.type, this.currentWork}) : uuid = const Uuid().v4();

  final String uuid;
  final String name;
  final TaskType type;
  double progress = -1; // -1 for indeterminate task, 0 - 1 for task progress
  String? currentWork;

  @override
  String toString() {
    return "Task($name, $progress, $currentWork)";
  }
}

enum TaskType { microsoftAuth, gameDownload, gameLaunch, javaDownload, checkUpdate }
