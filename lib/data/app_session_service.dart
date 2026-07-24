import 'local_auth_service.dart';

class AppSessionService {
  AppSessionService._();

  static final AppSessionService instance = AppSessionService._();

  SavedCredentials? _currentUser;

  SavedCredentials? get currentUser => _currentUser;

  void setCurrentUser(SavedCredentials user) {
    _currentUser = user;
  }

  void clear() {
    _currentUser = null;
  }

  Future<SavedCredentials?> resolveCurrentUser() async {
    return _currentUser ?? LocalAuthService.instance.readSavedCredentials();
  }
}
