import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/application/state/notification_notifier.dart';
import 'package:green_heart/domain/type/result.dart';

class NotificationDeleteUsecase {
  final NotificationRepository _notificationRepository;
  final NotificationNotifier _notificationNotifier;

  NotificationDeleteUsecase(
    this._notificationRepository,
    this._notificationNotifier,
  );

  Future<Result> execute(String notificationId, String uid) async {
    try {
      await _notificationRepository.deleteById(notificationId, uid);
      _notificationNotifier.deleteById(notificationId);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
