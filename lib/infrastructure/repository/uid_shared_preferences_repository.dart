import 'package:shared_preferences/shared_preferences.dart';

import 'package:green_heart/application/interface/shared_preferences_repository.dart';

class UidSharedPreferencesRepository implements SharedPreferencesRepository {
  @override
  Future<String?> get() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  @override
  Future<void> save(String uid) async {
    if (uid.isEmpty) {
      throw Exception('ユーザーIDが取得できませんでした。再度お試しください。');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
  }
}
