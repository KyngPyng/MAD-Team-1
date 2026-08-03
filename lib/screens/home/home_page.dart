import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/mock_data_repository.dart';
import '../../screens/submitdeliverable/submit_deliverable_screen.dart';
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
  bool _showErrorBanner = true;

  void _onSubmitButtonPressed(BuildContext context) {
    final enrolledPrograms = MockDataRepository.instance.programs
        .where((program) => program.isEnrolled)
        .toList();

    if (enrolledPrograms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are not currently enrolled in any programs.'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (modalContext) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Enrolled Program',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose which program you are submitting this deliverable for:',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: enrolledPrograms.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final program = enrolledPrograms[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(program.image),
                        backgroundColor: Colors.grey[200],
                      ),
                      title: Text(
                        program.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('${program.duration} • ${program.level}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.of(modalContext).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SubmitDeliverableScreen(
                              selectedProgram: program,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final programs = MockDataRepository.instance.programs;
    final projects = MockDataRepository.instance.projects;
    final loadError = MockDataRepository.instance.loadError;

    final activeProjects =
        projects.where((project) => project.progress < 1).toList();

    // Collect all tasks across active projects
    final allTasks =
        activeProjects.expand((project) => project.tasks).toList();
    
    // Safely filter completed and upcoming tasks using ?? false
    final upcomingTasks =
        allTasks.where((task) => !(task.isCompleted ?? false)).take(3).toList();

    final featuredProgram = programs.isNotEmpty ? programs.first : null;

    final totalTasksCount = allTasks.length;
    final completedTasksCount =
        allTasks.where((task) => task.isCompleted ?? false).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            if (loadError != null && _showErrorBanner) ...[
              MaterialBanner(
                backgroundColor: Colors.red.withValues(alpha: 0.08),
                content: Text(
                  loadError,
                  style: const TextStyle(color: Colors.redAccent),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showErrorBanner = false;
                      });
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            const HomeAppBar(),
            const SizedBox(height: 30),
            const GreetingSection(name: 'Aneal'),
            const SizedBox(height: 28),
            const SearchBarWidget(),
            const SizedBox(height: 35),

            // --- 1. SUMMARY STATS CARD ---
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
                  _buildStatItem('Programs', '${programs.length}', Icons.school_outlined),
                  _buildVerticalDivider(),
                  _buildStatItem('Active Projects', '${activeProjects.length}', Icons.folder_open_outlined),
                  _buildVerticalDivider(),
                  _buildStatItem('Pending Tasks', '${upcomingTasks.length}', Icons.task_alt_outlined),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // --- 2. FEATURED PROGRAM BANNER ---
            if (featuredProgram != null) ...[
              const SectionHeader(title: 'Featured Program'),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProgramDetailsPage(program: featuredProgram),
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
                    image: DecorationImage(
                      image: NetworkImage(featuredProgram.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
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
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_awesome, color: Colors.white, size: 12),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color: Colors.white.withValues(alpha: 0.8),
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
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
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
                ),
              ),
              const SizedBox(height: 35),
            ],

            // --- 3. DAILY PROGRESS BAR & QUICK ACTIONS ---
            _buildDailyProgressBar(
              completedTasks: completedTasksCount,
              totalTasks: totalTasksCount > 0 ? totalTasksCount : 4,
            ),
            const SizedBox(height: 16),

            _buildQuickActionsBar(context),
            const SizedBox(height: 35),

            // --- 4. UPCOMING TASKS ---
            const SectionHeader(title: 'Upcoming Tasks'),
            const SizedBox(height: 18),

            if (upcomingTasks.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No pending tasks for today!',
                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              )
            else
              ...upcomingTasks.map((task) {
                final parentProject = activeProjects.firstWhere(
                  (project) => project.tasks.any(
                    (t) => t.title == task.title && t.dueDate == task.dueDate,
                  ),
                  orElse: () => activeProjects.first,
                );

                return TaskTile(
                  task: task,
                  programName: parentProject.title,
                );
              }),

            const SizedBox(height: 20),

            // --- 5. RECENT ACTIVITY ---
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

  // --- WIDGET: DAILY PROGRESS BAR ---
  Widget _buildDailyProgressBar({
    required int completedTasks,
    required int totalTasks,
  }) {
    final double progress =
        totalTasks > 0 ? (completedTasks / totalTasks).clamp(0.0, 1.0) : 0.0;
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                Container(
                  height: 12,
                  color: Colors.grey.shade200,
                ),
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

  // --- WIDGET: QUICK ACTIONS BAR ---
  Widget _buildQuickActionsBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _onSubmitButtonPressed(context),
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

  // --- HELPER METHODS FOR STATS CARD ---
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
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 35,
      width: 1,
      color: Colors.grey.shade200,
    );
  }
}