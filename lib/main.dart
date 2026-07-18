import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/login/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
