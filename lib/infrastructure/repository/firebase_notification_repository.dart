import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/domain/type/notification.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseNotificationRepository implements NotificationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _timeoutSeconds = 10;

  @override
  Future<void> addNotification(
      String uid, String deviceId, String fcmToken) async {
    try {
      final notification = Notification(
        uid: uid,
        deviceId: deviceId,
        token: fcmToken,
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('profile')
          .doc(uid)
          .collection('notification')
          .add(notification.toJson())
          .timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('通知情報の保存に失敗しました。');
    }
  }

  @override
  Future<Notification?> getNotification(String uid, String deviceId) async {
    try {
      final snapshot = await _firestore
          .collection('profile')
          .doc(uid)
          .collection('notification')
          .where('deviceId', isEqualTo: deviceId)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));

      if (snapshot.docs.isEmpty) return null;

      return Notification.fromJson(snapshot.docs.first.data());
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('通知情報の取得に失敗しました。');
    }
  }

  @override
  Future<void> updateNotification(
    String uid,
    String deviceId,
    String fcmToken,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('profile')
          .doc(uid)
          .collection('notification')
          .where('deviceId', isEqualTo: deviceId)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));

      if (snapshot.docs.isEmpty) return;

      for (final doc in snapshot.docs) {
        await doc.reference.update({
          'token': fcmToken,
          'updatedAt': DateTime.now(),
        }).timeout(Duration(seconds: _timeoutSeconds));
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('通知情報の更新に失敗しました。');
    }
  }
}
