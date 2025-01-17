import 'package:green_heart/application/interface/app_info_service.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class AppVersionGetUsecase {
  final AppInfoService _appInfoService;

  AppVersionGetUsecase(this._appInfoService);

  Future<String?> execute() async {
    try {
      return await _appInfoService.getAppVersion();
    } catch (e, stackTrace) {
      await ExceptionHandler.handleException(e, stackTrace);
      return null;
    }
  }
}
