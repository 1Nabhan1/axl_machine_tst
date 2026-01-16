import 'package:axel_tech/data/services/session_manager/session_storage.dart';
import 'package:hive/hive.dart';

class CacheService {
  static final _sessionService = SessionService();

  static Future<void> clearAll(bool logout) async {
    await Hive.box('todos').clear();
    await Hive.box('favorites').clear();

    if(logout) {
      await Hive.box('user').clear();
      await _sessionService.clear(); // SharedPreferences
    }
  }
}
