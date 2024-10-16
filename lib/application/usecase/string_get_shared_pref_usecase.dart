import 'package:green_heart/application/interface/shared_pref_service.dart';

class StringGetSharedPrefUsecase {
  final SharedPrefService _sharedPrefService;

  StringGetSharedPrefUsecase(this._sharedPrefService);

  Future<String?> execute(String key) async {
    return await _sharedPrefService.getString(key);
  }
}
