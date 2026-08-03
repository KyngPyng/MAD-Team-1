import 'package:shared_preferences/shared_preferences.dart';

class SavedCredentials {
  final String name;
  final String email;
  final String password;
  final String role;

  const SavedCredentials({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}

class LocalAuthService {
  LocalAuthService._();

  static final LocalAuthService instance = LocalAuthService._();

  static const _nameKey = 'teamSync.name';
  static const _emailKey = 'teamSync.email';
  static const _passwordKey = 'teamSync.password';
  static const _roleKey = 'teamSync.role';

  // Demo Learner Credentials
  static const demoEmail = 'demo@teamsync.com';
  static const demoPassword = 'Demo@123';

  // Admin Preset Credentials & Secret Code
  static const adminEmail = 'admin@teamsync.com';
  static const adminPassword = 'Admin@123';
  static const adminSecretCode = 'TS-8942-ADM';

  Future<void> saveRegistration({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
    await prefs.setString(_roleKey, role);
  }

  Future<SavedCredentials?> readSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);
    final password = prefs.getString(_passwordKey);
    if (email == null || password == null) {
      return null;
    }

    return SavedCredentials(
      name: prefs.getString(_nameKey) ?? '',
      email: email,
      password: password,
      role: prefs.getString(_roleKey) ?? 'Learner',
    );
  }

  Future<SavedCredentials?> authenticate({
    required String email,
    required String password,
    required String fallbackRole,
    String? secretCode,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();
    final cleanSecretCode = secretCode?.trim();
    final normalizedRole = fallbackRole.trim().toLowerCase();

    // 1. DIRECT ADMIN CHECK (Check email + password first, normalize role)
    if (normalizedRole == 'admin' || cleanEmail == adminEmail.toLowerCase()) {
      if (cleanEmail != adminEmail.toLowerCase()) {
        return null;
      }
      if (cleanPassword != adminPassword) {
        return null;
      }
      // Validate secret code if provided or required
      if (cleanSecretCode != null && cleanSecretCode != adminSecretCode) {
        return null;
      }

      return const SavedCredentials(
        name: 'System Admin',
        email: adminEmail,
        password: adminPassword,
        role: 'Admin',
      );
    }

    // 2. DEMO LEARNER CHECK
    if (cleanEmail == demoEmail.toLowerCase() && cleanPassword == demoPassword) {
      return const SavedCredentials(
        name: 'Demo User',
        email: demoEmail,
        password: demoPassword,
        role: 'Learner',
      );
    }

    // 3. REGISTERED LOCAL USER CHECK
    final saved = await readSavedCredentials();
    if (saved != null &&
        saved.email.trim().toLowerCase() == cleanEmail &&
        saved.password == cleanPassword) {
      return saved;
    }

    return null;
  }
}