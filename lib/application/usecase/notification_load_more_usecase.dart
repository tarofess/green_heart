import 'package:green_heart/application/interface/notification_repository.dart';
import 'package:green_heart/application/state/notification_notifier.dart';
import 'package:green_heart/domain/type/result.dart';

class NotificationLoadMoreUsecase {
  final NotificationRepository _notificationRepository;
  final NotificationNotifier _notificationNotifier;
  final String? _uid;

  NotificationLoadMoreUsecase(
    this._notificationRepository,
    this._notificationNotifier,
    this._uid,
  );

  Future<Result> execute() async {
    if (_uid == null) {
      return const Failure('ユーザー情報が取得できませんでした。再度お試しください。');
    }

    try {
      final notifications =
          await _notificationRepository.getNotifications(_uid);
      await _notificationNotifier.loadMore(notifications);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
