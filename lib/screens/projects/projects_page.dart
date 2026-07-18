import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../models/project_model.dart';
import '../../widgets/project_card.dart';
import 'project_details_page.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activeProjects = projects.where((project) => project.progress < 1);
    final completedProjects = projects.where(
      (project) => project.progress >= 1,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        children: [
          Text(
            'Active Projects',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ...activeProjects.map(
            (project) => _ProjectListItem(project: project),
          ),
          const SizedBox(height: 20),
          Text(
            'Completed Projects',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          if (completedProjects.isEmpty)
            const Text('Completed projects will appear here.'),
          ...completedProjects.map(
            (project) => _ProjectListItem(project: project),
          ),
        ],
      ),
    );
  }
}

class _ProjectListItem extends StatelessWidget {
  final ProjectModel project;

  const _ProjectListItem({required this.project});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 246,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ProjectCard(
          project: project,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProjectDetailsPage(project: project),
            ),
          ),
        ),
      ),
    );
  }
}
