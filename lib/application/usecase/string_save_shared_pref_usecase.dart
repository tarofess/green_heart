import 'package:green_heart/application/interface/shared_pref_service.dart';

class StringSaveSharedPrefUsecase {
  final SharedPrefService _sharedPrefService;

  StringSaveSharedPrefUsecase(this._sharedPrefService);

  Future<void> execute(String key, String value) async {
    try {
      await _sharedPrefService.setString(key, value);
    } catch (e) {
      throw Exception('文字列の保存中にエラーが発生しました。再度お試しください。');
    }
  }
}
