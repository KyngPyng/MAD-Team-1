import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../data/program_dummy_data.dart';
import '../../screens/programs/program_details_page.dart';
import '../../screens/projects/project_details_page.dart';
import '../../screens/teams/team_dashboard_page.dart'; 
import '../../widgets/greeting_section.dart';
import '../../widgets/home_appbar.dart';
import '../../widgets/program_card.dart';
import '../../widgets/project_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_header.dart';
import '../../widgets/task_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final activeProjects = projects
        .where((project) => project.progress < 1)
        .toList();
    final upcomingTasks = activeProjects
        .expand((project) => project.tasks)
        .take(3);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            const HomeAppBar(),
            const SizedBox(height: 30),
            const GreetingSection(),
            const SizedBox(height: 28),
            const SearchBarWidget(),
            const SizedBox(height: 35),
            const SectionHeader(title: 'Continue Learning'),
            const SizedBox(height: 18),
            SizedBox(
              height: 540,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: programs.length,
                separatorBuilder: (_, _) => const SizedBox(width: 18),
                itemBuilder: (context, index) => SizedBox(
                  width: 280,
                  child: ProgramCard(
                    program: programs[index],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ProgramDetailsPage(program: programs[index]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            const SectionHeader(title: 'Active Projects'),
            const SizedBox(height: 18),
            SizedBox(
              height: 230,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: activeProjects.length,
                separatorBuilder: (_, _) => const SizedBox(width: 18),
                itemBuilder: (context, index) {
                  final currentProject = activeProjects[index];
                  
                  return ProjectCard(
                    project: currentProject,
                    onTap: () {
                      if (currentProject.title == "Team Dashboard") {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TeamDashboardPage(
                              program: programs.first, 
                            ),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProjectDetailsPage(project: currentProject),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 35),
            const SectionHeader(title: 'Upcoming Tasks'),
            const SizedBox(height: 18),
            
            // Updated to find the matching project title for each task item
            ...upcomingTasks.map((task) {
              final parentProject = activeProjects.firstWhere(
                (project) => project.tasks.any((t) => t.title == task.title && t.dueDate == task.dueDate),
                orElse: () => activeProjects.first,
              );

              return TaskTile(
                task: task,
                programName: parentProject.title,
              );
            }),
            
            const SizedBox(height: 20),
            const SectionHeader(title: 'Recent Activity'),
            const Card(
              child: ListTile(
                leading: Icon(Icons.check_circle_outline),
                title: Text('Project update shared'),
                subtitle: Text('Team Dashboard • Today'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.school_outlined),
                title: Text('Learning progress updated'),
                subtitle: Text('Flutter Development • Yesterday'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}