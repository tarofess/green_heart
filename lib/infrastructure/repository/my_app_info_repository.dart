import 'package:package_info_plus/package_info_plus.dart';

import 'package:green_heart/application/interface/app_info_repository.dart';

class MyAppInfoRepository implements AppInfoRepository {
  @override
  Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
