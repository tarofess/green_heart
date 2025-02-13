import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:green_heart/application/interface/notification_setting_repository.dart';

class NotificationSaveUsecase {
  final NotificationSettingRepository _notificationRepository;

  NotificationSaveUsecase(this._notificationRepository);

  Future<void> execute(String? uid, String deviceId) async {
    try {
      // FCMの現在のトークンを取得
      final currentToken = await FirebaseMessaging.instance.getToken();
      if (uid == null || currentToken == null) return;

      // ユーザー＆デバイスに紐づく通知情報を取得
      final savedNotification =
          await _notificationRepository.getNotificationSetting(uid, deviceId);

      // このデバイスのトークンがまだ保存されていなければ新規追加
      if (savedNotification == null) {
        await _notificationRepository.addNotificationSetting(
          uid,
          deviceId,
          currentToken,
        );
        return;
      }

      // 同じデバイスでトークンが変更されていた場合は更新
      if (savedNotification.token != currentToken) {
        await _notificationRepository.updateNotificationSetting(
          uid,
          deviceId,
          currentToken,
        );
        return;
      }
    } catch (e) {
      return;
    }
  }
}
