import 'package:flutter/material.dart';
import 'package:pencil/data/task/tasks_provider.dart';
import 'package:provider/provider.dart';

class TasksIndicator extends StatelessWidget {
  const TasksIndicator({super.key, required this.showTasks()});

  final void Function() showTasks;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TasksProvider tasks = Provider.of<TasksProvider>(context);

    return tasks.getTasks().isEmpty
        ? IconButton(icon: const Icon(Icons.check), onPressed: showTasks)
        : SizedBox(
            width: 32,
            height: 32,
            child: InkWell(
                onTap: showTasks,
                borderRadius: BorderRadius.circular(16),
                child: Stack(children: [
                  const CircularProgressIndicator(),
                  Center(
                      child: Text(tasks.getTasks().length <= 9 ? tasks.getTasks().length.toString() : '9+',
                          style: theme.textTheme.bodyMedium!.copyWith(fontFamily: 'Product Sans')))
                ])));
  }
}
