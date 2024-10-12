import 'package:green_heart/application/interface/shared_pref_service.dart';

class StringGetSharedPrefUsecase {
  final SharedPrefService _sharedPrefService;

  StringGetSharedPrefUsecase(this._sharedPrefService);

  Future<String?> execute(String key) async {
    try {
      return await _sharedPrefService.getString(key);
    } catch (e) {
      throw Exception('文字列の取得中にエラーが発生しました。再度お試しください。');
    }
  }
}
