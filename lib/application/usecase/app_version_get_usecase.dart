import 'package:green_heart/application/interface/app_info_service.dart';

class AppVersionGetUsecase {
  final AppInfoService _appInfoService;

  AppVersionGetUsecase(this._appInfoService);

  Future<String> execute() async {
    try {
      return await _appInfoService.getAppVersion();
    } catch (e) {
      throw Exception('アプリの情報を取得できませんでした。');
    }
  }
}
