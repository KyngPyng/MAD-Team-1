import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/app_session_service.dart';
import 'data/local_auth_service.dart';
import 'data/mock_data_repository.dart';
import 'screens/admin/admin_navigation_page.dart';
import 'screens/login/login_page.dart';
import 'screens/main_navigation_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MockDataRepository.instance.load();

  final initialSession = await AppSessionService.instance
      .resolveLaunchSession();
  if (initialSession != null) {
    AppSessionService.instance.setCurrentUser(initialSession);
  }

  runApp(TeamSyncApp(initialSession: initialSession));
}

class TeamSyncApp extends StatelessWidget {
  const TeamSyncApp({super.key, this.initialSession});

  final SavedCredentials? initialSession;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeamSync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: initialSession?.role == 'Admin'
          ? const AdminNavigationPage()
          : initialSession != null
          ? const MainNavigationPage()
          : const LoginPage(),
    );
  }
}
