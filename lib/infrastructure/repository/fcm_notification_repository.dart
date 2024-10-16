import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FcmNotificationRepository implements NotificationRepository {
  @override
  Future<void> saveFcmToken(String uid, String fcmToken) async {
    try {
      await FirebaseFirestore.instance.collection('fcmToken').doc(uid).set({
        'token': fcmToken,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('fcmTokenの保存に失敗しました。');
    }
  }
}
