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
  static const _rememberKey = 'teamSync.rememberMe';
  static const _sessionNameKey = 'teamSync.session.name';
  static const _sessionEmailKey = 'teamSync.session.email';
  static const _sessionPasswordKey = 'teamSync.session.password';
  static const _sessionRoleKey = 'teamSync.session.role';

  static const demoEmail = 'demo@teamsync.com';
  static const demoPassword = 'Demo@123';

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

  Future<void> saveRememberedSession(SavedCredentials user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberKey, true);
    await prefs.setString(_sessionNameKey, user.name);
    await prefs.setString(_sessionEmailKey, user.email);
    await prefs.setString(_sessionPasswordKey, user.password);
    await prefs.setString(_sessionRoleKey, user.role);
  }

  Future<SavedCredentials?> readRememberedSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_rememberKey) != true) {
      return null;
    }

    final email = prefs.getString(_sessionEmailKey);
    final password = prefs.getString(_sessionPasswordKey);
    if (email == null || password == null) {
      return null;
    }

    return SavedCredentials(
      name: prefs.getString(_sessionNameKey) ?? '',
      email: email,
      password: password,
      role: prefs.getString(_sessionRoleKey) ?? 'Learner',
    );
  }

  Future<bool> isRememberMeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberKey) ?? false;
  }

  Future<void> clearRememberedSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberKey);
    await prefs.remove(_sessionNameKey);
    await prefs.remove(_sessionEmailKey);
    await prefs.remove(_sessionPasswordKey);
    await prefs.remove(_sessionRoleKey);
  }

  Future<SavedCredentials?> authenticate({
    required String email,
    required String password,
    required String fallbackRole,
  }) async {
    final saved = await readSavedCredentials();
    if (saved != null &&
        saved.email.toLowerCase() == email.toLowerCase() &&
        saved.password == password) {
      return saved;
    }

    final isDemoLogin =
        email.toLowerCase() == demoEmail && password == demoPassword;
    if (isDemoLogin) {
      return SavedCredentials(
        name: 'Demo User',
        email: demoEmail,
        password: demoPassword,
        role: fallbackRole,
      );
    }

    return null;
  }
}
