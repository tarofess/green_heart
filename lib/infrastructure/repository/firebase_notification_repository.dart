import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseNotificationRepository implements NotificationRepository {
  final int _timeoutSeconds = 15;

  @override
  Future<void> saveFcmToken(String uid, String fcmToken) async {
    try {
      await FirebaseFirestore.instance.collection('fcmToken').doc(uid).set({
        'token': fcmToken,
        'timestamp': FieldValue.serverTimestamp(),
      }).timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('fcmTokenの保存に失敗しました。');
    }
  }

  @override
  Future<void> deleteFcmToken(String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('fcmToken')
          .doc(uid)
          .delete()
          .timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('fcmTokenの削除に失敗しました。');
    }
  }
}
