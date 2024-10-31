import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/notification_repository.dart';

class FcmTokenDeleteUsecase {
  final NotificationRepository _notificationRepository;

  FcmTokenDeleteUsecase(this._notificationRepository);

  Future<void> execute(User user) async {
    try {
      await _notificationRepository.deleteFcmToken(user.uid);
    } catch (e) {
      throw AppException(
        '通知トークンの削除に失敗したためアカウントが削除できませんでした。\n'
        'アカウントを削除するために後ほどもう一度お試しください。',
        e,
      );
    }
  }
}
