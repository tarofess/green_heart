import 'package:green_heart/application/interface/shared_pref_service.dart';

class SharedPrefSaveUsecase {
  final SharedPrefService _sharedPrefService;

  SharedPrefSaveUsecase(this._sharedPrefService);

  Future<void> execute(String key, String value) async {
    await _sharedPrefService.setString(key, value);
  }
}
