import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _isLoggedIn = 'is_logged_in';
  static const _failedAttempts = 'failed_attempts';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedIn) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedIn, value);
  }

  Future<int> getFailedAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_failedAttempts) ?? 0;
  }

  Future<void> incrementFailedAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_failedAttempts) ?? 0;
    await prefs.setInt(_failedAttempts, count + 1);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
