import 'package:flutter/material.dart';

import '../widgets/floating_bottom_nav.dart';
import 'home/home_page.dart';
import 'programs/programs_page.dart';
import 'projects/projects_page.dart';
import 'teams/team_dashboard_page.dart';
import '../data/program_dummy_data.dart'; // Imports the dummy data for the team dashboard model

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  // RESTORED: Increased back to 4 slots to match the new item count
  final _navigatorKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const ProgramsPage(),
      const ProjectsPage(),
      TeamDashboardPage(program: programs.first), // NEW: Direct top-level access slot
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
        body: IndexedStack(
          index: _currentIndex,
          children: List.generate(
            pages.length,
            (index) => Navigator(
              key: _navigatorKeys[index],
              onGenerateRoute: (_) =>
                  MaterialPageRoute(builder: (_) => pages[index]),
            ),
          ),
        ),
        bottomNavigationBar: FloatingBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}