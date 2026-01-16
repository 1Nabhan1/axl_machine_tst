import 'package:hive/hive.dart';
import '../models/user_model.dart';

class AccountRepository {
  final _box = Hive.box('user');

  UserModel? getUser() {
    final data = _box.get('profile');
    if (data == null) return null;
    return UserModel.fromMap(Map<String, dynamic>.from(data));
  }

  Future<void> saveUser(UserModel user) async {
    await _box.put('profile', user.toMap());

    await _box.put(user.username, user.toMap());
  }

  Future<void> clearUser() async {
    await _box.delete('profile');
  }

  Future<void> clearCache() async {
    await Hive.box('todos').clear();
  }
}
