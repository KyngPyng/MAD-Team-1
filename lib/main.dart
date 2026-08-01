import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Added Firebase Core
import 'firebase_options.dart'; // 2. Added generated Firebase Options for mad-teamsync

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
    return MaterialApp(
      title: 'TeamSync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}