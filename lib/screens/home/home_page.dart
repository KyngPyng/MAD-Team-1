import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/app_session_service.dart';
import '../../data/local_auth_service.dart';
import '../../data/mock_data_repository.dart';
import '../../screens/programs/program_details_page.dart';
import '../../widgets/greeting_section.dart';
import '../../widgets/home_appbar.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/section_header.dart';
import '../../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<SavedCredentials?> _accountFuture = AppSessionService
      .instance
      .resolveCurrentUser();

  @override
  Widget build(BuildContext context) {
    final programs = MockDataRepository.instance.programs;
    final projects = MockDataRepository.instance.projects;
    final loadError = MockDataRepository.instance.loadError;
    final activeProjects = projects
        .where((project) => project.progress < 1)
        .toList();
    final upcomingTasks = activeProjects
        .expand((project) => project.tasks)
        .take(3)
        .toList();
    final featuredProgram = programs.isNotEmpty ? programs.first : null;
    final totalTasksCount = upcomingTasks.length;
    final completedTasksCount = upcomingTasks
        .where((task) => task.completed)
        .length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            if (loadError != null) ...[
              MaterialBanner(
                backgroundColor: Colors.red.withValues(alpha: 0.08),
                content: Text(loadError),
                actions: [
                  TextButton(onPressed: () {}, child: const Text('OK')),
                ],
              ),
              const SizedBox(height: 16),
            ],
            const HomeAppBar(),
            const SizedBox(height: 30),
            FutureBuilder<SavedCredentials?>(
              future: _accountFuture,
              builder: (context, snapshot) {
                final account = snapshot.data;
                return GreetingSection(
                  name: account?.name.isNotEmpty == true
                      ? account!.name
                      : 'Aryan',
                );
              },
            ),
            const SizedBox(height: 28),
            const SearchBarWidget(),
            const SizedBox(height: 35),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Programs',
                    '${programs.length}',
                    Icons.school_outlined,
                  ),
                  _buildVerticalDivider(),
                  _buildStatItem(
                    'Active Projects',
                    '${activeProjects.length}',
                    Icons.folder_open_outlined,
                  ),
                  _buildVerticalDivider(),
                  _buildStatItem(
                    'Pending Tasks',
                    '${upcomingTasks.length}',
                    Icons.task_alt_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            if (featuredProgram != null) ...[
              const SectionHeader(title: 'Featured Program'),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ProgramDetailsPage(program: featuredProgram),
                  ),
                ),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          featuredProgram.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF1C2A55),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: Colors.white,
                              size: 52,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.black.withValues(alpha: 0.15),
                                Colors.black.withValues(alpha: 0.85),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.auto_awesome,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'SPOTLIGHT',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          featuredProgram.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            height: 1.2,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'By ${featuredProgram.mentor}',
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
            ],
            _buildDailyProgressBar(
              completedTasks: completedTasksCount,
              totalTasks: totalTasksCount > 0 ? totalTasksCount : 4,
            ),
            const SizedBox(height: 16),
            _buildQuickActionsBar(context),
            const SizedBox(height: 35),
            const SectionHeader(title: 'Upcoming Tasks'),
            const SizedBox(height: 18),
            ...upcomingTasks.map((task) {
              final parentProject = activeProjects.firstWhere(
                (project) => project.tasks.any(
                  (t) => t.title == task.title && t.dueDate == task.dueDate,
                ),
                orElse: () => activeProjects.first,
              );

              return TaskTile(task: task, programName: parentProject.title);
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

  Widget _buildDailyProgressBar({
    required int completedTasks,
    required int totalTasks,
  }) {
    final double progress = totalTasks > 0
        ? (completedTasks / totalTasks).clamp(0.0, 1.0)
        : 0.0;
    final int percentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF7B7BFF).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF7B7BFF).withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B7BFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Daily Progress',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B7BFF).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B5BFF),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Container(height: 12, color: Colors.grey.shade200),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      height: 12,
                      width: constraints.maxWidth * progress,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7B7BFF),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$completedTasks of $totalTasks daily targets completed',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload_file_rounded, size: 18),
            label: const Text('Submit Task'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.calendar_today_rounded, size: 18),
            label: const Text('View Schedule'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 35, width: 1, color: Colors.grey.shade200);
  }
}
