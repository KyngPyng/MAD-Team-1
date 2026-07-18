import 'package:flutter/material.dart';

import '../../models/task_model.dart';

class TaskDetailsPage extends StatelessWidget {
  final TaskModel task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text('Due: ${task.dueDate}'),
            const SizedBox(height: 24),
            Chip(label: Text(task.completed ? 'Completed' : 'Open')),
          ],
        ),
      ),
    );
  }
}
