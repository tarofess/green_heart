import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/application/state/notification_notifier.dart';
import 'package:green_heart/domain/type/notification.dart';

class NotificationMarkAsReadUsecase {
  final NotificationRepository _notificationRepository;
  final NotificationNotifier _notificationNotifier;

  NotificationMarkAsReadUsecase(
    this._notificationRepository,
    this._notificationNotifier,
  );

  Future<void> execute(Notification notification) async {
    try {
      await _notificationRepository.markAsRead(notification);
      _notificationNotifier.markAsRead(notification);
    } catch (e) {
      return;
    }
  }
}
