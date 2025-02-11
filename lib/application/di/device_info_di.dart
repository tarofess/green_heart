import 'package:device_info_plus/device_info_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/device_info_get_usecase.dart';
import 'package:green_heart/infrastructure/service/my_device_info_service.dart';

final deviceInfoGetUsecaseProvider = Provider(
  (ref) => DeviceInfoGetUsecase(
    MyDeviceInfoService(
      DeviceInfoPlugin(),
    ),
  ),
);
