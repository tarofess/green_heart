import 'package:shared_preferences/shared_preferences.dart';

import 'package:green_heart/application/interface/shared_pref_service.dart';

class GenericSharedPrefService implements SharedPrefService {
  @override
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
