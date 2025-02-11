import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingHandlersService {
  void setupNotificationHandlers() {
    _handleForegroundMessage();
    _handleBackgroundMessage();
    _handleInitialMessage();
  }

  void _handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
  }

  void _handleBackgroundMessage() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  Future<void> _handleInitialMessage() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {}
  }
}
