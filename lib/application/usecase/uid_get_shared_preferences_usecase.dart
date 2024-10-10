import 'package:green_heart/application/interface/shared_preferences_repository.dart';

class UidGetSharedPreferencesUsecase {
  final SharedPreferencesRepository _sharedPreferencesRepository;

  UidGetSharedPreferencesUsecase(this._sharedPreferencesRepository);

  Future<String?> execute() async {
    try {
      return await _sharedPreferencesRepository.get();
    } catch (e) {
      throw Exception('ユーザーIDの取得中にエラーが発生しました。再度お試しください。');
    }
  }
}
