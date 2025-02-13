import 'package:green_heart/application/interface/notification_setting_repository.dart';
import 'package:green_heart/domain/type/notification_setting.dart';

class NotificationSettingGetUsecase {
  final NotificationSettingRepository _notificationSettingRepository;

  NotificationSettingGetUsecase(this._notificationSettingRepository);

  Future<NotificationSetting?> execute(String uid, String deviceId) async {
    try {
      return await _notificationSettingRepository.getNotificationSetting(
        uid,
        deviceId,
      );
    } catch (e) {
      return null;
    }
  }
}
