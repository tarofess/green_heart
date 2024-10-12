import 'package:green_heart/application/interface/shared_preferences_service.dart';

class StringGetSharedPreferencesUsecase {
  final SharedPreferencesService _sharedPreferencesService;

  StringGetSharedPreferencesUsecase(this._sharedPreferencesService);

  Future<String?> execute(String key) async {
    try {
      return await _sharedPreferencesService.get(key);
    } catch (e) {
      throw Exception('文字列の取得中にエラーが発生しました。再度お試しください。');
    }
  }
}