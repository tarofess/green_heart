import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingHandlersService {
  void setupNotificationHandlers() {
    _handleForegroundMessage();
    _handleBackgroundMessage();
    _handleInitialMessage();
  }

  void _handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // フォアグラウンドでの通知処理
    });
  }

  void _handleBackgroundMessage() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // バックグラウンドでの通知タップ処理
    });
  }

  Future<void> _handleInitialMessage() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      // アプリが終了している状態での通知タップ処理
    }
  }
}
