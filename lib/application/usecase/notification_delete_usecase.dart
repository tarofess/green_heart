import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/notification_repository.dart';

class NotificationDeleteUsecase {
  final NotificationRepository _notificationRepository;

  NotificationDeleteUsecase(this._notificationRepository);

  Future<void> execute(User user) async {
    try {
      await _notificationRepository.deleteNotification(user.uid);
    } catch (e) {
      throw AppException(
        '通知トークンの削除に失敗したためアカウントが削除できませんでした。\n'
        'アカウントを削除するために後ほどもう一度お試しください。',
        e,
      );
    }
  }
}
