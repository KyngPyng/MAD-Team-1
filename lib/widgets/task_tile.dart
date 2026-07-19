import 'package:flutter/material.dart';

import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final String? programName; // Added optional program name parameter

  const TaskTile({
    super.key, 
    required this.task, 
    this.programName, // Included in constructor
  });

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
        // Added the program badge chip as trailing element
        secondary: programName != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B7BFF).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  programName!,
                  style: const TextStyle(
                    color: Color(0xFF7B7BFF),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}