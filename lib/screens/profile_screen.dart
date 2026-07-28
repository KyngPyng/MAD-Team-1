import 'package:flutter/material.dart';

import '../data/app_session_service.dart';
import '../data/local_auth_service.dart';
import '../screens/feedback/feedback_form_page.dart';
import '../screens/login/login_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static Future<void> showBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ProfileSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountFuture = AppSessionService.instance.resolveCurrentUser();

    return FutureBuilder<SavedCredentials?>(
      future: accountFuture,
      builder: (context, snapshot) {
        final account = snapshot.data;
        return _ProfileScaffold(account: account, showHeader: true);
      },
    );
  }
}

class _ProfileSheet extends StatelessWidget {
  const _ProfileSheet();

  @override
  Widget build(BuildContext context) {
    final accountFuture = AppSessionService.instance.resolveCurrentUser();

    return SafeArea(
      child: FutureBuilder<SavedCredentials?>(
        future: accountFuture,
        builder: (context, snapshot) {
          final account = snapshot.data;
          return _ProfileScaffold(account: account, showHeader: false);
        },
      ),
    );
  }
}

class _ProfileScaffold extends StatelessWidget {
  final SavedCredentials? account;
  final bool showHeader;

  const _ProfileScaffold({required this.account, required this.showHeader});

  @override
  Widget build(BuildContext context) {
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

    final body = SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!showHeader) ...[
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const SizedBox(width: 12),
                Text(
                  isAdmin ? 'Admin Management Profile' : 'teamSync Profile',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ],
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
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
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
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const FeedbackFormPage())),
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
              onPressed: () async {
                await LocalAuthService.instance.clearRememberedSession();
                AppSessionService.instance.clear();
                if (!context.mounted) return;
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
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
    );

    if (!showHeader) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isAdmin ? 'Admin Profile' : 'teamSync Profile',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: isAdmin
                          ? Colors.indigo.shade100
                          : Colors.deepPurple.shade100,
                      child: Icon(
                        isAdmin ? Icons.admin_panel_settings : Icons.person,
                        size: 34,
                        color: isAdmin ? Colors.indigo : Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        isAdmin ? 'Global' : '12/15',
                        isAdmin ? 'Scope Access' : 'Tasks Done',
                        isAdmin ? Colors.indigo : Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMetricCard(
                        context,
                        isAdmin ? 'Level 4' : '95%',
                        isAdmin ? 'Security Clearance' : 'Attendance',
                        isAdmin ? Colors.indigo : Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSettingsTile(
                  context,
                  icon: isAdmin ? Icons.security : Icons.email,
                  title: isAdmin ? 'Audit Logs' : 'Email Address',
                  subtitle: isAdmin ? 'Review secure history' : email,
                  color: isAdmin ? Colors.indigo : Colors.deepPurple,
                ),
                _buildSettingsTile(
                  context,
                  icon: isAdmin
                      ? Icons.supervised_user_circle
                      : Icons.notifications,
                  title: isAdmin ? 'Privilege Panel' : 'Slack Sync Alerts',
                  subtitle: isAdmin
                      ? 'Manage active allocations'
                      : 'Enabled (15 mins prior)',
                  color: isAdmin ? Colors.indigo : Colors.deepPurple,
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.feedback_outlined,
                  title: 'Send Feedback',
                  subtitle: 'Share your thoughts',
                  color: isAdmin ? Colors.indigo : Colors.deepPurple,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FeedbackFormPage()),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await LocalAuthService.instance.clearRememberedSession();
                      AppSessionService.instance.clear();
                      if (!context.mounted) return;
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
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (showHeader) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            isAdmin ? 'Admin Management Profile' : 'teamSync - My Profile',
          ),
          backgroundColor: Colors.deepPurple.shade50,
        ),
        body: body,
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Material(color: Colors.white, child: body),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
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
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap ?? () {},
    );
  }
}
