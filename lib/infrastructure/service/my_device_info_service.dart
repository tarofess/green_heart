import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:green_heart/application/interface/device_info_service.dart';

class MyDeviceInfoService implements DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo;

  MyDeviceInfoService(this._deviceInfo);

  @override
  Future<String?> getDeviceId() async {
    try {
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        String? deviceId = iosInfo.identifierForVendor;

        return deviceId;
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        String? deviceId = androidInfo.id;

        return deviceId;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
