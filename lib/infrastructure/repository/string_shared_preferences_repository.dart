import 'package:shared_preferences/shared_preferences.dart';

import 'package:green_heart/application/interface/shared_preferences_repository.dart';

class StringSharedPreferencesRepository implements SharedPreferencesRepository {
  @override
  Future<String?> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
