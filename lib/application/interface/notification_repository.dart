import 'package:green_heart/domain/type/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> getNotifications(String uid);
  Future<void> markAsRead(Notification notification);
  Future<void> deleteById(String notificationId, String uid);
}
