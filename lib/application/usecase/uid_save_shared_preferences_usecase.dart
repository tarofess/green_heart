import 'package:green_heart/application/interface/shared_preferences_service.dart';

class UidSaveSharedPreferencesUsecase {
  final SharedPreferencesService _sharedPreferencesService;

  UidSaveSharedPreferencesUsecase(this._sharedPreferencesService);

  Future<void> execute(String key, String value) async {
    try {
      await _sharedPreferencesService.save(key, value);
    } catch (e) {
      throw Exception('文字列の保存中にエラーが発生しました。再度お試しください。');
    }
  }
}
