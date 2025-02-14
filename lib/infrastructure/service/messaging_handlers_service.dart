import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:green_heart/application/state/selected_tab_index_notifier.dart';

class MessagingHandlersService {
  SelectedTabIndexNotifier selectedIndexNotifier;

  MessagingHandlersService(this.selectedIndexNotifier);

  void setupNotificationHandlers() {
    _handleForegroundMessage();
    _handleBackgroundMessage();
    _handleInitialMessage();
  }

  void _handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
  }

  void _handleBackgroundMessage() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      selectedIndexNotifier.setSelectedIndex(2);
    });
  }

  Future<void> _handleInitialMessage() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      selectedIndexNotifier.setSelectedIndex(2);
    }
  }
}
