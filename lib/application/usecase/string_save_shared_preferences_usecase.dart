import 'package:green_heart/application/interface/shared_preferences_repository.dart';

class StringSaveSharedPreferencesUsecase {
  final SharedPreferencesRepository _sharedPreferencesRepository;

  StringSaveSharedPreferencesUsecase(this._sharedPreferencesRepository);

  Future<void> execute(String key, String value) async {
    try {
      await _sharedPreferencesRepository.save(key, value);
    } catch (e) {
      throw Exception('文字列の保存中にエラーが発生しました。再度お試しください。');
    }
  }
}
