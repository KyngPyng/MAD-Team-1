import 'package:flutter/material.dart';

import '../data/app_session_service.dart';
import '../widgets/floating_bottom_nav.dart';
import '../admin/home/admin_home_page.dart';
import 'home/home_page.dart';
import 'programs/programs_page.dart';
import 'projects/projects_page.dart';

class MainNavigationPage extends StatefulWidget {
  final String? userRole;

  const MainNavigationPage({super.key, this.userRole});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  final _navigatorKeys = List.generate(3, (_) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    // Determine active role from widget arg, route setting, or saved session
    final routeArgRole = ModalRoute.of(context)?.settings.arguments as String?;
    final activeRole = widget.userRole ??
        routeArgRole ??
        AppSessionService.instance.currentUser?.role ??
        'Learner';

    final isAdmin = activeRole.trim().toLowerCase() == 'admin';

    // Role-based page routing stack
    final List<Widget> pages = isAdmin
        ? const [
            AdminHomeScreen(), // Admin Dashboard (Only page needed if no bottom nav)
          ]
        : const [
            HomePage(),        // Student Dashboard at Index 0
            ProgramsPage(),    // Student Programs
            ProjectsPage(),    // Student Projects
          ];

    return PopScope(
      canPop: !(_navigatorKeys[_currentIndex].currentState?.canPop() ?? false),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop &&
            (_navigatorKeys[_currentIndex].currentState?.canPop() ?? false)) {
          _navigatorKeys[_currentIndex].currentState!.pop();
        }
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFDFEFF), Color(0xFFF2F6FF)],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IndexedStack(
                index: isAdmin ? 0 : _currentIndex, // Lock to index 0 for Admin
                children: List.generate(
                  pages.length,
                  (index) => Navigator(
                    key: index < _navigatorKeys.length 
                        ? _navigatorKeys[index] 
                        : GlobalKey<NavigatorState>(),
                    onGenerateRoute: (_) => MaterialPageRoute(
                      builder: (_) => pages[index],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // CONDITIONALLY HIDE THE BOTTOM NAV BAR
        bottomNavigationBar: isAdmin
            ? null 
            : FloatingBottomNav(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
              ),
      ),
    );
  }
}