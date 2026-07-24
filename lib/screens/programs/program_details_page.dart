import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/program_model.dart';
import '../teams/team_dashboard_page.dart'; // Navigates to the team dashboard file path

class ProgramDetailsPage extends StatefulWidget {
  final ProgramModel program;

  const ProgramDetailsPage({super.key, required this.program});

  @override
  State<ProgramDetailsPage> createState() => _ProgramDetailsPageState();
}

class _ProgramDetailsPageState extends State<ProgramDetailsPage> {
  late bool _isEnrolled;

  @override
  void initState() {
    super.initState();
    _isEnrolled = widget.program.isEnrolled;
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeamDashboardPage(program: widget.program),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final program = widget.program;

    return Scaffold(
      appBar: AppBar(title: Text(program.title)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // --- REGION-BOUND TEAM ACCESS LINK BANNER ---
          if (_isEnrolled) ...[
            GestureDetector(
              onTap: () => _navigateToDashboard(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.gradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.groups_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Assigned Workspace",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Sub Team 7 Workspace",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _navigateToDashboard(context),
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        padding: const EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],

          Text(program.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('${program.level} • ${program.duration}'),
          const SizedBox(height: 20),
          Text(
            program.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
            title: const Text('Mentor'),
            // Updated property from program.mentor to program.instructor
            subtitle: Text(program.mentor), 
          ),
          const SizedBox(height: 16),
          Text(
            'What you will learn',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          // Updated collection from program.modules to program.topics
          ...program.modules.map(
            (topic) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle_outline),
              title: Text(topic),
            ),
          ),
          const SizedBox(height: 16),
          if (_isEnrolled) ...[
            Text(
              'Your progress',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: program.progress),
            const SizedBox(height: 8),
            Text('${(program.progress * 100).round()}% completed'),
          ] else
            Text(
              'You are not enrolled in this program yet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              if (_isEnrolled) return;
              setState(() => _isEnrolled = true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You are enrolled. Start learning!'),
                ),
              );
            },
            icon: Icon(
              _isEnrolled ? Icons.play_arrow_rounded : Icons.add_circle_outline,
            ),
            label: Text(_isEnrolled ? 'Continue Learning' : 'Enroll Now'),
          ),
        ],
      ),
    );
  }
}
