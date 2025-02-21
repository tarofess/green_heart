import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/application/state/notification_notifier.dart';
import 'package:green_heart/application/state/notification_scroll_state_notifier.dart';
import 'package:green_heart/domain/type/result.dart';

class NotificationRefreshUsecase {
  final NotificationRepository _repository;
  final NotificationNotifier _notificationNotifier;
  final NotificationScrollStateNotifier _notificationScrollStateNotifier;
  final String? _uid;

  NotificationRefreshUsecase(
    this._repository,
    this._notificationNotifier,
    this._notificationScrollStateNotifier,
    this._uid,
  );

  Future<Result> execute() async {
    if (_uid == null) {
      return const Failure('ユーザー情報が取得できませんでした。再度お試しください。');
    }

    try {
      _notificationScrollStateNotifier.reset();

      final notifications = await _repository.getNotifications(_uid);
      await _notificationNotifier.refresh(notifications);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
