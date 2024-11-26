import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/domain/type/notification.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseNotificationRepository implements NotificationRepository {
  final int _timeoutSeconds = 10;

  @override
  Future<Notification?> getNotificationByUid(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notification')
          .doc(uid)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));
      if (snapshot.exists) {
        return Notification.fromJson(snapshot.data()!);
      }
      return null;
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('通知情報の取得に失敗しました。');
    }
  }

  @override
  Future<void> saveNotification(String uid, String fcmToken) async {
    try {
      final notification = Notification(
        uid: uid,
        token: fcmToken,
        updatedAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('notification')
          .doc(uid)
          .set(notification.toJson())
          .timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('通知情報の保存に失敗しました。');
    }
  }

  @override
  Future<void> deleteNotification(String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('notification')
          .doc(uid)
          .delete()
          .timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('通知情報の削除に失敗しました。');
    }
  }
}
