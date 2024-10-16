import 'package:shared_preferences/shared_preferences.dart';

import 'package:green_heart/application/interface/shared_pref_service.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class GenericSharedPrefService implements SharedPrefService {
  @override
  Future<String?> getString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      final exception = ExceptionHandler.handleException(e);
      throw exception ?? AppException('端末に保存された文字列の取得に失敗しました。');
    }
  }

  @override
  Future<void> setString(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (e) {
      final exception = ExceptionHandler.handleException(e);
      throw exception ?? AppException('端末に文字列を保存する時にエラーが発生しました。');
    }
  }
}
