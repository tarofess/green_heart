import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/domain/type/notification.dart';

class NotificationGetUsecase {
  final NotificationRepository _notificationRepository;

  NotificationGetUsecase(this._notificationRepository);

  Future<List<Notification>> execute(String uid) {
    return _notificationRepository.getNotifications(uid);
  }
}
