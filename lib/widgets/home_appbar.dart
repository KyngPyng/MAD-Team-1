// Inside lib/widgets/home_appbar.dart
import 'package:flutter/material.dart';
import '../data/mock_data_repository.dart';
import '../screens/teams/team_dashboard_page.dart';
import '../screens/profile_screen.dart'; // Import your profile screen here

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false, // Prevents accidental back arrows
      title: const Text(
        'Workspace',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      actions: [
        // The Team Dashboard overlay trigger icon
        IconButton(
          icon: const Icon(
            Icons.groups_rounded,
            color: Color(0xFF7B7BFF),
            size: 28,
          ),
          tooltip: 'Select Sub Group',
          onPressed: () => _showSubGroupSelection(context),
        ),
        const SizedBox(width: 4),

        // Interactive Profile Tab Button
        GestureDetector(
          onTap: () {
            // UPDATED: Using rootNavigator targets the top-level stack above the navigation shell
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
                // Make sure to match the expected string argument check in your ProfileScreen state
                settings: const RouteSettings(arguments: "Learner"),
              ),
            );
          },
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFECEAFF),
            child: Icon(
              Icons.person_outline_rounded,
              color: Color(0xFF7B7BFF),
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showSubGroupSelection(BuildContext context) {
    // Filters out only tracks the student is actively enrolled in
    final activeTracks = MockDataRepository.instance.programs
        .where((p) => p.isEnrolled)
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Team Workspace',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Jump directly into your active subgroup dashboard.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: activeTracks.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('No active program cohorts found.'),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: activeTracks.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final track = activeTracks[index];

                          return InkWell(
                            onTap: () {
                              Navigator.pop(context); // Dismiss selection sheet
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TeamDashboardPage(program: track),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F2F9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFF7B7BFF)
                                        .withValues(alpha: 0.15),
                                    child: const Icon(
                                      Icons.hub_rounded,
                                      color: Color(0xFF7B7BFF),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          track.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${track.level} • Sub Group 7',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}