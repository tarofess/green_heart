import 'package:green_heart/application/interface/device_info_service.dart';

class DeviceInfoGetUsecase {
  final DeviceInfoService _deviceInfoService;

  DeviceInfoGetUsecase(this._deviceInfoService);

  Future<String?> execute() async {
    return await _deviceInfoService.getDeviceId();
  }
}
