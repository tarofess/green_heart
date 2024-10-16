import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/interface/notification_repository.dart';

class FcmNotificationRepository implements NotificationRepository {
  @override
  Future<void> saveFcmToken(String uid, String fcmToken) async {
    try {
      await FirebaseFirestore.instance.collection('fcmToken').doc(uid).set({
        'token': fcmToken,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('fcmTokenの保存に失敗しました。');
    }
  }
}
