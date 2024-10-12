import 'package:green_heart/application/interface/shared_preferences_repository.dart';

class StringGetSharedPreferencesUsecase {
  final SharedPreferencesRepository _sharedPreferencesRepository;

  StringGetSharedPreferencesUsecase(this._sharedPreferencesRepository);

  Future<String?> execute(String key) async {
    try {
      return await _sharedPreferencesRepository.get(key);
    } catch (e) {
      throw Exception('文字列の取得中にエラーが発生しました。再度お試しください。');
    }
  }
}
