import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<String?> getUid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('uid');
    } catch (e) {
      throw Exception('ユーザーIDの取得中にエラーが発生しました。再度お試しください。');
    }
  }

  Future<void> saveUid(String uid) async {
    try {
      if (uid.isEmpty) {
        throw Exception('ユーザーIDが取得できませんでした。再度お試しください。');
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', uid);
    } catch (e) {
      throw Exception('ユーザーIDの保存中にエラーが発生しました。再度お試しください。');
    }
  }
}
