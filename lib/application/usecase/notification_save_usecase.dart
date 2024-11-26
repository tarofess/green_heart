import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:green_heart/application/interface/notification_repository.dart';

class NotificationSaveUsecase {
  final NotificationRepository _notificationRepository;

  NotificationSaveUsecase(this._notificationRepository);

  Future<void> execute(String uid) async {
    final currentToken = await FirebaseMessaging.instance.getToken();
    final savedNotification =
        await _notificationRepository.getNotificationByUid(uid);

    if (currentToken != null &&
        (savedNotification == null ||
            currentToken != savedNotification.token)) {
      await _notificationRepository.saveNotification(uid, currentToken);
    }
  }
}
