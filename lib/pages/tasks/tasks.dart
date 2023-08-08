import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pencil/data/pencil/task/task.dart';
import 'package:pencil/data/pencil/task/tasks_provider.dart';
import 'package:provider/provider.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key, required this.hideTasks});

  final void Function() hideTasks;

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TasksProvider tasks = Provider.of<TasksProvider>(context);
    List<Task> tasksList = tasks.getTasks();

    return Stack(children: [
      SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(56),
              height: tasksList.isEmpty ? MediaQuery.of(context).size.height : null,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (tasksList.isEmpty)
                  Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(bottom: 16), child: Text(FlutterI18n.translate(context, 'tasks.title'), style: theme.textTheme.headlineLarge)))
                else
                  Container(
                      margin: const EdgeInsets.only(bottom: 16), child: Text(FlutterI18n.translate(context, 'tasks.title'), style: theme.textTheme.headlineLarge)),
                for (Task task in tasksList) Container(margin: const EdgeInsets.only(bottom: 16), child: TaskWidget(task: task)),
                if (tasksList.isEmpty)
                  Expanded(
                      child: Center(
                          child: Column(children: [
                    Container(margin: const EdgeInsets.only(bottom: 8), child: const Icon(Icons.check, size: 64)),
                    I18nText('tasks.noTasks')
                  ])))
              ]))),
      Positioned(
          left: 0,
          top: 0,
          child: Container(
              margin: const EdgeInsets.all(8),
              child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.hideTasks)))
    ]);
  }
}

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: theme.colorScheme.inversePrimary.withAlpha(30)),
        child: Row(children: [
          Container(margin: const EdgeInsets.only(right: 12), child: const Icon(Icons.person)),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                margin: task.currentWork == null ? const EdgeInsets.only(bottom: 8) : null,
                child: Text(task.name,
                    style: theme.textTheme.bodyMedium!.copyWith(fontFamily: 'Product Sans', fontWeight: FontWeight.w700))),
            if (task.currentWork != null)
              Container(
                  margin: const EdgeInsets.only(bottom: 8), child: Text(task.currentWork!, style: theme.textTheme.bodySmall)),
            LinearProgressIndicator(value: task.progress == -1 ? null : task.progress)
          ]))
        ]));
  }
}
