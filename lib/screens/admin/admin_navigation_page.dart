import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'admin_dashboard_page.dart';
import 'admin_programs_page.dart';
import 'admin_reports_page.dart';
import 'admin_users_page.dart';
import '../../widgets/admin_bottom_nav.dart';

class AdminNavigationPage extends StatefulWidget {
  const AdminNavigationPage({super.key});

  @override
  State<AdminNavigationPage> createState() => _AdminNavigationPageState();
}

class _AdminNavigationPageState extends State<AdminNavigationPage> {
  int _currentIndex = 0;
  bool _didShowFlashMessage = false;
  DateTime? _lastBackPressedAt;
  late final PageController _pageController = PageController();

  final _navigatorKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didShowFlashMessage) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['flashMessage'] is String) {
      _didShowFlashMessage = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(args['flashMessage'] as String)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const AdminDashboardPage(),
      const AdminUsersPage(),
      const AdminProgramsPage(),
      const AdminReportsPage(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final navigator = _navigatorKeys[_currentIndex].currentState;
        if (navigator?.canPop() ?? false) {
          navigator!.pop();
          return;
        }

        final now = DateTime.now();
        if (_lastBackPressedAt != null &&
            now.difference(_lastBackPressedAt!) < const Duration(seconds: 2)) {
          SystemNavigator.pop();
          return;
        }

        _lastBackPressedAt = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Press back again to exit')),
        );
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
                    colors: [const Color(0xFFF8FAFF), const Color(0xFFEFEFFF)],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  if (index != _currentIndex) {
                    setState(() => _currentIndex = index);
                  }
                },
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
        bottomNavigationBar: AdminBottomNav(
          currentIndex: _currentIndex,
          onTap: _selectTab,
        ),
      ),
    );
  }

  void _selectTab(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }
}
