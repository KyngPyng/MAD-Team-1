import 'package:flutter/material.dart';

import '../data/app_session_service.dart';
import '../data/local_auth_service.dart';
import '../screens/login/login_page.dart';
import 'feedback/feedback_form_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Future<SavedCredentials?> _accountFuture = AppSessionService
      .instance
      .resolveCurrentUser();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SavedCredentials?>(
      future: _accountFuture,
      builder: (context, snapshot) {
        final account = snapshot.data;
        final String userRole =
            account?.role ??
            (ModalRoute.of(context)?.settings.arguments as String?) ??
            'Learner';
        final bool isAdmin = userRole == 'Admin';
        final String displayName = account?.name.isNotEmpty == true
            ? account!.name
            : (isAdmin ? 'Director Operations Office' : 'Alex Mensah');
        final String email = account?.email.isNotEmpty == true
            ? account!.email
            : (isAdmin
                  ? 'admin@teamsync.local'
                  : 'alex.mensah@excelerate-learner.com');
        final String subtitle = account?.role != null
            ? '${account!.role} • ${isAdmin ? 'System Administrator Tier 1' : 'Excelerate Cohort 4'}'
            : (isAdmin
                  ? 'System Administrator Tier 1'
                  : 'Learner (Team Lead) • Excelerate Cohort 4');

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
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),
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
                    subtitle: email,
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
                _buildSettingsTile(
                  context,
                  icon: Icons.feedback_outlined,
                  title: 'Send Feedback',
                  subtitle: 'Share your thoughts with the team.',
                  color: isAdmin ? Colors.indigo : Colors.deepPurple,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FeedbackFormPage()),
                  ),
                ),
                const SizedBox(height: 40),
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
                      AppSessionService.instance.clear();
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap ?? () {},
    );
  }
}
