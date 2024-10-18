abstract class NotificationRepository {
  Future<void> saveFcmToken(String uid, String fcmToken);
  Future<void> deleteFcmToken(String uid);
}
