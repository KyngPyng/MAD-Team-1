import 'dart:ui';
import 'package:flutter/material.dart';

import '../../data/app_session_service.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppSessionService.instance.currentUser;
    final adminName = user?.name.isNotEmpty == true ? user!.name : 'Administrator';
    final adminEmail = user?.email.isNotEmpty == true ? user!.email : 'admin@teamsync.com';

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Admin Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        child: Column(
          children: [
            // 1. Admin Info Glass Header
            _buildProfileHeader(adminName, adminEmail),
            const SizedBox(height: 20),

            // 2. Admin System Controls Section
            _buildSectionHeader('System Administration'),
            const SizedBox(height: 10),
            _buildGlassGroup([
              _buildSettingTile(
                icon: Icons.groups_outlined,
                iconColor: const Color(0xFF6366F1),
                title: 'Manage Subgroups',
                subtitle: 'Reassign or add new student groups',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.campaign_outlined,
                iconColor: const Color(0xFF0EA5E9),
                title: 'Broadcast Announcement',
                subtitle: 'Push notification to all enrolled students',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.file_download_outlined,
                iconColor: const Color(0xFF10B981),
                title: 'Export Platform Analytics',
                subtitle: 'Download student progress CSV/PDF reports',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 20),

            // 3. Security & Session
            _buildSectionHeader('Security & Session'),
            const SizedBox(height: 10),
            _buildGlassGroup([
              _buildSettingTile(
                icon: Icons.shield_outlined,
                iconColor: const Color(0xFF8B5CF6),
                title: 'Admin Secret Key',
                subtitle: 'Secret Code: TS-8942-ADM',
                onTap: () {},
              ),
              _buildSettingTile(
                icon: Icons.lock_reset_rounded,
                iconColor: const Color(0xFFF59E0B),
                title: 'Change Password',
                subtitle: 'Update account credentials',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),

            // 4. Logout Action Tile
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  // --- Glassmorphic Profile Header ---
  Widget _buildProfileHeader(String name, String email) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF6366F1), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.2),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 36,
                      backgroundColor: Color(0xFFEEF2FF),
                      child: Icon(Icons.person, size: 40, color: Color(0xFF6366F1)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 12, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                email,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFC7D2FE)),
                ),
                child: const Text(
                  'SYSTEM ADMINISTRATOR',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4F46E5),
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Section Heading ---
  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF64748B),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // --- Glass Group Container ---
  Widget _buildGlassGroup(List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(children.length, (index) {
              if (index == children.length - 1) return children[index];
              return Column(
                children: [
                  children[index],
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // --- Individual Setting Tile ---
  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xFF1E293B),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD5E1)),
      onTap: onTap,
    );
  }

  // --- Logout Action ---
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          await AppSessionService.instance.clear();
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true)
                .pushReplacementNamed('/login');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFEE2E2),
          foregroundColor: const Color(0xFFDC2626),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text(
          'Sign Out of Session',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }
}