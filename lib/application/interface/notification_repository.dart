import 'package:green_heart/domain/type/notification.dart';

abstract class NotificationRepository {
  Future<Notification?> getNotification(String uid, String deviceId);
  Future<void> addNotification(String uid, String deviceId, String token);
  Future<void> updateNotification(String uid, String deviceId, String token);
}
