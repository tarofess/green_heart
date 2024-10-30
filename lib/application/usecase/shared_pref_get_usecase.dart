import 'package:green_heart/application/interface/shared_pref_service.dart';

class SharedPrefGetUsecase {
  final SharedPrefService _sharedPrefService;

  SharedPrefGetUsecase(this._sharedPrefService);

  Future<String?> execute(String key) async {
    return await _sharedPrefService.getString(key);
  }
}
