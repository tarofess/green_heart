import 'package:green_heart/domain/type/notification_setting.dart';

abstract class NotificationSettingRepository {
  Future<NotificationSetting?> getNotificationSetting(
    String uid,
    String deviceId,
  );
  Future<void> addNotificationSetting(
    String uid,
    String deviceId,
    String token,
  );
  Future<void> updateNotificationSetting(
    String uid,
    String deviceId,
    String token,
  );
  Future<void> updateEachNotificationStatus(
    String uid,
    String deviceId,
    bool likeSetting,
    bool commentSetting,
    bool followerSetting,
  );
}
