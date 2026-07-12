import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get the generic arguments object safely without casting upfront
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    
    // 2. Initialize default values
    String username = 'Team Lead'; 
    String userRole = 'Learner';

    // 3. Check the runtime type dynamically to prevent the TypeError crash
    if (args is Map) {
      username = args['username']?.toString() ?? 'User';
      userRole = args['role']?.toString() ?? 'Learner';
    } else if (args is String) {
      // Fallback if login screen only passes the role string
      userRole = args;
      username = userRole == 'Admin' ? 'Administrator' : 'Team Lead';
    }

    final bool isAdmin = userRole == 'Admin';
    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'teamSync - Admin Portal' : 'teamSync - Dashboard'),
        backgroundColor: Colors.deepPurple.shade50,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile', arguments: userRole);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header greeting using the custom typed username text
            Text(
              'Hello, $username',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isAdmin 
                  ? 'Global platform management and strategic cohort oversight.'
                  : 'Track your project tracks, updates, and upcoming milestones.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // Conditional Dashboard Widgets
            if (isAdmin) ...[
              // Admin-Specific Management Grid
              const Text(
                'Cohort Summary Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildAdminStatCard('Active Cohorts', '4 active')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildAdminStatCard('Pending Reviews', '18 items')),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: const ListTile(
                  leading: Icon(Icons.analytics, color: Colors.indigo),
                  title: Text('System Operations Status'),
                  subtitle: Text('All subsystems running normally.'),
                ),
              ),
            ] else ...[
              // Learner-Specific Content
              const Text(
                'Urgent Deadlines',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                color: Colors.red.shade50,
                child: const ListTile(
                  leading: Icon(Icons.warning, color: Colors.red),
                  title: Text('Week 1 Deliverables Submissions', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Due: Monday, July 13th'),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Pinned Core Content Block
            const Text(
              'Recent System Announcements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.campaign, color: Colors.deepPurple),
                    title: Text('Project Kickoff Guidelines Posted'),
                    subtitle: Text('Review operations and setup parameters.'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.group, color: Colors.deepPurple),
                    title: Text('Daily Sync Schedule Established'),
                    subtitle: Text('Friday - Sunday sync blocks locked in.'),
                  ),
                ],
              ),
            ),
            
            // Render program list navigation ONLY for Learners
            if (!isAdmin) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/programs');
                },
                icon: const Icon(Icons.assignment),
                label: const Text('View Program Tracks & Tasks', style: TextStyle(fontSize: 16)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdminStatCard(String title, String state) {
    return Card(
      color: Colors.indigo.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 14, color: Colors.indigo.shade900, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(state, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}