import 'package:flutter/material.dart';

import '../widgets/floating_bottom_nav.dart';
import 'home/home_page.dart';
import 'programs/programs_page.dart';
import 'projects/projects_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final _navigatorKeys = List.generate(3, (_) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const ProgramsPage(),
      const ProjectsPage(),
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
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [const Color(0xFFFDFEFF), const Color(0xFFF2F6FF)],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IndexedStack(
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
            ),
          ],
        ),
        bottomNavigationBar: FloatingBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
