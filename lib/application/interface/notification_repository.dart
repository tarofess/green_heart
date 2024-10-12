abstract class NotificationRepository {
  Future<void> saveFcmToken(String uid, String fcmToken);
}
