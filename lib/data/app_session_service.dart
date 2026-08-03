import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_auth_service.dart';

class AppSessionService {
  AppSessionService._();

  static final AppSessionService instance = AppSessionService._();

  static const _sessionNameKey = 'teamSync.session.name';
  static const _sessionEmailKey = 'teamSync.session.email';
  static const _sessionRoleKey = 'teamSync.session.role';

  SavedCredentials? _currentUser;

  SavedCredentials? get currentUser => _currentUser;

  /// Saves the authenticated user into memory AND device storage.
  Future<void> setCurrentUser(SavedCredentials user) async {
    _currentUser = user;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionNameKey, user.name);
    await prefs.setString(_sessionEmailKey, user.email);
    await prefs.setString(_sessionRoleKey, user.role);
    
    debugPrint('AppSessionService: Saved active session for ${user.email} as ${user.role}');
  }

  /// Clears active session state on logout.
  Future<void> clear() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionNameKey);
    await prefs.remove(_sessionEmailKey);
    await prefs.remove(_sessionRoleKey);
  }

  /// Resolves the current user: checks RAM first, then active session storage,
  /// and only falls back to saved registration if no active session exists.
  Future<SavedCredentials?> resolveCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_sessionEmailKey);
    final name = prefs.getString(_sessionNameKey);
    final role = prefs.getString(_sessionRoleKey);

    if (email != null && role != null) {
      _currentUser = SavedCredentials(
        name: name ?? '',
        email: email,
        password: '', // Hidden/Unneeded for active session
        role: role,
      );
      return _currentUser;
    }

    // Fallback to locally registered credentials if no explicit session was saved
    return LocalAuthService.instance.readSavedCredentials();
  }
}