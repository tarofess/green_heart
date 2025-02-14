import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/device_info_di.dart';
import 'package:green_heart/application/di/notification_setting_di.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class NotificationSetupNotifier extends AsyncNotifier {
  @override
  Future<void> build() async {
    await setupMessaging();

    try {
      final deviceId = await ref.read(deviceInfoGetUsecaseProvider).execute();
      if (deviceId == null) return;

      await ref.read(notificationSaveUsecaeProvider).execute(
            ref.watch(authStateProvider).value?.uid,
            deviceId,
          );
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('通知の設定に失敗しました。再度お試しください。');
    }
  }

  Future<void> setupMessaging() async {
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: false,
        sound: true,
      );

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: false,
        sound: true,
      );
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('通知の初期化に失敗しました。再度お試しください。');
    }
  }
}

final notificationSetupNotifierProvider =
    AsyncNotifierProvider<NotificationSetupNotifier, void>(
  () => NotificationSetupNotifier(),
);
