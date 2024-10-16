import 'package:package_info_plus/package_info_plus.dart';

import 'package:green_heart/application/interface/app_info_service.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class MyAppInfoService implements AppInfoService {
  @override
  Future<String> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      final exception = ExceptionHandler.handleException(e);
      throw exception ?? AppException('アプリのバージョンを取得できませんでした。');
    }
  }
}
