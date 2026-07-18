import 'package:flutter/material.dart';

import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: CheckboxListTile(
        value: task.completed,
        onChanged: (_) {},
        title: Text(task.title),
        subtitle: Text("Due: ${task.dueDate}"),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
