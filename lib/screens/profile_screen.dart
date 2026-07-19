import 'package:flutter/material.dart';
import '../screens/login/login_page.dart'; // Make sure this path correctly points to your LoginPage file

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userRole =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? 'Learner';
    final bool isAdmin = userRole == 'Admin';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAdmin ? 'Admin Management Profile' : 'teamSync - My Profile',
        ),
        backgroundColor: Colors.deepPurple.shade50,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            // Dynamic Profile Image Container
            CircleAvatar(
              radius: 60,
              backgroundColor: isAdmin
                  ? Colors.indigo.shade100
                  : Colors.deepPurple.shade100,
              child: Icon(
                isAdmin ? Icons.admin_panel_settings : Icons.person,
                size: 80,
                color: isAdmin ? Colors.indigo : Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),

            // Custom Metadata display blocks
            Text(
              isAdmin ? 'Director Operations Office' : 'Alex Mensah',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              isAdmin
                  ? 'System Administrator Tier 1'
                  : 'Learner (Team Lead) • Excelerate Cohort 4',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // Metric UI updates conditionally based on dynamic permission level
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: isAdmin
                  ? [
                      _buildMetricCard(
                        context,
                        'Global',
                        'Scope Access',
                        Colors.indigo,
                      ),
                      _buildMetricCard(
                        context,
                        'Level 4',
                        'Security Clearance',
                        Colors.indigo,
                      ),
                    ]
                  : [
                      _buildMetricCard(
                        context,
                        '12/15',
                        'Tasks Done',
                        Colors.deepPurple,
                      ),
                      _buildMetricCard(
                        context,
                        '95%',
                        'Attendance',
                        Colors.deepPurple,
                      ),
                    ],
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            // Action lists specific to structural capabilities
            if (isAdmin) ...[
              _buildSettingsTile(
                context,
                icon: Icons.security,
                title: 'Encryption & Audit Logs',
                subtitle: 'Review secure transaction history logs.',
                color: Colors.indigo,
              ),
              _buildSettingsTile(
                context,
                icon: Icons.supervised_user_circle,
                title: 'User Privilege Panel',
                subtitle: 'Manage active system allocations.',
                color: Colors.indigo,
              ),
            ] else ...[
              _buildSettingsTile(
                context,
                icon: Icons.email,
                title: 'Email Address',
                subtitle: 'alex.mensah@excelerate-learner.com',
                color: Colors.deepPurple,
              ),
              _buildSettingsTile(
                context,
                icon: Icons.notifications,
                title: 'Slack Sync Alerts',
                subtitle: 'Enabled (15 mins prior to Daily Sync)',
                color: Colors.deepPurple,
              ),
            ],
            const SizedBox(height: 40),

            // Clear authentication navigation action hook
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red),
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // UPDATED: Destroys the entire layout stack from the root context shell 
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String value,
    String label,
    Color accentColor,
  ) {
    return Card(
      elevation: 2,
      color: accentColor.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}