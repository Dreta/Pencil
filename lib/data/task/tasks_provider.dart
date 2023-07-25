import 'package:flutter/material.dart';
import 'package:pencil/data/task/task.dart';

class TasksProvider extends ChangeNotifier {
  final Map<TaskType, Map<String, Task>> tasks = {};

  void addTask(Task task) {
    if (!tasks.containsKey(task.type)) {
      tasks[task.type] = {};
    }
    tasks[task.type]![task.uuid] = task;
    notify();
  }

  void removeTask(Task task) {
    tasks[task.type]!.remove(task.uuid);
    if (tasks[task.type]!.isEmpty) {
      tasks.remove(task.type);
    }
    notify();
  }

  List<Task> getTasks() {
    List<Task> result = [];
    for (MapEntry<TaskType, Map<String, Task>> entry in tasks.entries) {
      result.addAll(entry.value.values);
    }
    return result;
  }

  void notify() {
    notifyListeners();
  }
}
