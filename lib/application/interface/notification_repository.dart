import 'package:green_heart/domain/type/notification.dart';

abstract class NotificationRepository {
  Future<Notification?> getNotificationByUid(String uid);
  Future<void> saveNotification(String uid, String fcmToken);
  Future<void> deleteNotification(String uid);
}
