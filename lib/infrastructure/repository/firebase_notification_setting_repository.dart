import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/notification_setting_repository.dart';
import 'package:green_heart/domain/type/notification_setting.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseNotificationSettingRepository
    implements NotificationSettingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _timeoutSeconds = 10;

  @override
  Future<void> addNotificationSetting(
    String uid,
    String deviceId,
    String fcmToken,
  ) async {
    try {
      final notification = NotificationSetting(
        uid: uid,
        deviceId: deviceId,
        token: fcmToken,
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('profile')
          .doc(uid)
          .collection('notificationSetting')
          .add(notification.toJson())
          .timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      if (e is TimeoutException) return;

      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('通知情報の保存に失敗しました。');
    }
  }

  @override
  Future<NotificationSetting?> getNotificationSetting(
    String uid,
    String deviceId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('profile')
          .doc(uid)
          .collection('notificationSetting')
          .where('deviceId', isEqualTo: deviceId)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));

      if (snapshot.docs.isEmpty) return null;

      return NotificationSetting.fromJson(snapshot.docs.first.data());
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('通知情報の取得に失敗しました。');
    }
  }

  @override
  Future<void> updateNotificationSetting(
    String uid,
    String deviceId,
    String fcmToken,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('profile')
          .doc(uid)
          .collection('notificationSetting')
          .where('deviceId', isEqualTo: deviceId)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));

      if (snapshot.docs.isEmpty) return;

      for (final doc in snapshot.docs) {
        await doc.reference.update({
          'token': fcmToken,
          'updatedAt': DateTime.now().toIso8601String(),
        }).timeout(Duration(seconds: _timeoutSeconds));
      }
    } catch (e, stackTrace) {
      if (e is TimeoutException) return;

      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('通知情報の更新に失敗しました。');
    }
  }

  @override
  Future<void> updateEachNotificationStatus(
    String uid,
    String deviceId,
    bool likeSetting,
    bool commentSetting,
    bool followerSetting,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('profile')
          .doc(uid)
          .collection('notificationSetting')
          .where('deviceId', isEqualTo: deviceId)
          .get()
          .timeout(Duration(seconds: _timeoutSeconds));

      if (snapshot.docs.isEmpty) return;

      for (final doc in snapshot.docs) {
        await doc.reference.update({
          'likeSetting': likeSetting,
          'commentSetting': commentSetting,
          'followerSetting': followerSetting,
          'updatedAt': DateTime.now().toIso8601String(),
        }).timeout(Duration(seconds: _timeoutSeconds));
      }
    } catch (e, stackTrace) {
      if (e is TimeoutException) return;

      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('通知設定の更新に失敗しました。');
    }
  }
}
