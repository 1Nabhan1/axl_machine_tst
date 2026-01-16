import 'package:hive/hive.dart';

import '../models/user_model.dart';

class AuthRepository {
  final _userBox = Hive.box('user');

  Future<void> register(UserModel user) async {
    if (_userBox.containsKey(user.username)) {
      throw Exception('Username already exists');
    }
    await _userBox.put(user.username, user.toMap());
  }

  Future<UserModel?> login(String username, String password) async {
    final data = _userBox.get(username);
    if (data == null) return null;

    final user = UserModel.fromMap(Map<String, dynamic>.from(data));
    if (user.password == password) {
      // ✅ CREATE SESSION
      await _userBox.put('profile', user.toMap());
      return user;
    }

    return null;
  }
}
