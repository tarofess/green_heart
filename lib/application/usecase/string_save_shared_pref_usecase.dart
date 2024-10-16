import 'package:green_heart/application/interface/shared_pref_service.dart';

class StringSaveSharedPrefUsecase {
  final SharedPrefService _sharedPrefService;

  StringSaveSharedPrefUsecase(this._sharedPrefService);

  Future<void> execute(String key, String value) async {
    await _sharedPrefService.setString(key, value);
  }
}
