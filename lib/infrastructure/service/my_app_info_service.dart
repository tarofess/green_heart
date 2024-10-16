import 'package:package_info_plus/package_info_plus.dart';

import 'package:green_heart/application/interface/app_info_service.dart';

class MyAppInfoService implements AppInfoService {
  @override
  Future<String> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      throw Exception('アプリの情報を取得できませんでした。');
    }
  }
}
