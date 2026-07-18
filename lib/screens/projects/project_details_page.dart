import 'package:flutter/material.dart';

import '../../models/project_model.dart';
import '../../widgets/task_tile.dart';
import 'task_details_page.dart';

class ProjectDetailsPage extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailsPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(value: project.progress),
          const SizedBox(height: 8),
          Text(
            '${(project.progress * 100).round()}% complete • Due ${project.dueDate}',
          ),
          const SizedBox(height: 24),
          Text('Team members', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: project.teamMembers
                .map((member) => Chip(label: Text(member)))
                .toList(),
          ),
          const SizedBox(height: 24),
          Text('Tasks', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...project.tasks.map(
            (task) => InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => TaskDetailsPage(task: task)),
              ),
              child: TaskTile(task: task),
            ),
          ),
        ],
      ),
    );
  }
}
