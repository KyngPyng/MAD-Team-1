import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'data/mock_data_repository.dart';
import 'screens/login/login_page.dart';

Future<void> main() async {
  // 1. Ensure Flutter bindings are ready BEFORE doing any async/asset loading
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase Core with mad-teamsync options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Initialize Service Locator (Dependency Injection)
  setupServiceLocator();

  // 4. Load mock data repository
  await MockDataRepository.instance.load();

  runApp(const TeamSyncApp());
}

class TeamSyncApp extends StatelessWidget {
  const TeamSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listens to themeModeNotifier to switch themes dynamically across TeamSync
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeModeNotifier,
      builder: (context, currentThemeMode, child) {
        return MaterialApp(
          title: 'TeamSync',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentThemeMode,
          home: const LoginPage(),
        );
      },
    );
  }
}