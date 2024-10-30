import 'package:green_heart/application/interface/shared_pref_service.dart';

class SharedPrefDeleteUsecase {
  final SharedPrefService _sharedPrefService;

  SharedPrefDeleteUsecase(this._sharedPrefService);

  Future<void> execute(String key) async {
    return _sharedPrefService.deleteString(key);
  }
}
