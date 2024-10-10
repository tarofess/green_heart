import 'package:green_heart/application/interface/shared_preferences_repository.dart';

class UidSaveSharedPreferencesUsecase {
  final SharedPreferencesRepository _sharedPreferencesRepository;

  UidSaveSharedPreferencesUsecase(this._sharedPreferencesRepository);

  Future<void> execute(String uid) async {
    try {
      await _sharedPreferencesRepository.save(uid);
    } catch (e) {
      throw Exception('ユーザーIDの保存中にエラーが発生しました。再度お試しください。');
    }
  }
}
