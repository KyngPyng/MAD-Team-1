import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/mock_data_repository.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final programs = MockDataRepository.instance.programs;
    final projects = MockDataRepository.instance.projects;
    final activeProjects = projects.where((project) => project.progress < 1);
    final completedProjects = projects.where(
      (project) => project.progress >= 1,
    );
    final openTasks = activeProjects.expand((project) => project.tasks).length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 120),
        children: [
          _AdminBanner(
            title: 'System Overview',
            subtitle: 'Monitor activity across programs, users, and projects.',
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 720 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: [
              _MetricCard(
                label: 'Programs',
                value: '${programs.length}',
                icon: Icons.menu_book_rounded,
                color: const Color(0xFF6C63FF),
              ),
              _MetricCard(
                label: 'Active Projects',
                value: '${activeProjects.length}',
                icon: Icons.folder_open_rounded,
                color: const Color(0xFF4F7FFF),
              ),
              _MetricCard(
                label: 'Open Tasks',
                value: '$openTasks',
                icon: Icons.task_alt_rounded,
                color: const Color(0xFF22A7F0),
              ),
              _MetricCard(
                label: 'Completed',
                value: '${completedProjects.length}',
                icon: Icons.verified_rounded,
                color: const Color(0xFF16A34A),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Recent Actions',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ...[
            (
              'Program "Flutter Basics" approved',
              '2 min ago',
              Icons.check_circle,
            ),
            (
              '3 new users registered',
              '18 min ago',
              Icons.person_add_alt_1_rounded,
            ),
            ('Project milestone updated', '1 hr ago', Icons.update_rounded),
          ].map(
            (entry) =>
                _ActionTile(title: entry.$1, time: entry.$2, icon: entry.$3),
          ),
          const SizedBox(height: 24),
          Text(
            'Admin Notices',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Text(
              'All admin panels are connected to the same local demo data source.',
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminBanner extends StatelessWidget {
  final String title;
  final String subtitle;

  const _AdminBanner({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.admin_panel_settings_rounded, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;

  const _ActionTile({
    required this.title,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF6C63FF).withValues(alpha: 0.12),
            child: Icon(icon, color: const Color(0xFF6C63FF)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
