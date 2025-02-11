import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/notification_save_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_notification_setting_repository.dart';
import 'package:green_heart/application/usecase/notification_setting_update_usecase.dart';
import 'package:green_heart/application/usecase/notification_setting_get_usecase.dart';

final notificationSaveUsecaeProvider = Provider(
  (ref) => NotificationSaveUsecase(
    FirebaseNotificationSettingRepository(),
  ),
);

final notificationSettingUpdateUsecaeProvider = Provider(
  (ref) => NotificationSettingUpdateUsecase(
    FirebaseNotificationSettingRepository(),
  ),
);

final notificationSettingGetUsecaseProvider = Provider(
  (ref) => NotificationSettingGetUsecase(
    FirebaseNotificationSettingRepository(),
  ),
);
