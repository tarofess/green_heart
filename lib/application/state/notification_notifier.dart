import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/notification_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/domain/type/notification.dart';
import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/domain/type/block.dart';

class NotificationNotifier extends AsyncNotifier<List<Notification>> {
  late AsyncValue<List<Block>> _blockState;
  List<Notification> _allNotifications = [];

  @override
  Future<List<Notification>> build() async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザー情報が取得できませんでした。再度お試しください。');
    }

    _blockState = ref.read(blockNotifierProvider);

    final notifications =
        await ref.read(notificationGetUsecaseProvider).execute(uid);
    final filteredNotifications = filterByBlock(notifications);

    // ブロックの状態変更で通知が変わるのに備えて全通知を保持しておく
    _allNotifications = filteredNotifications;

    // ブロック情報が更新された場合、保持している通知データに再度フィルターを適用する
    ref.listen<AsyncValue<List<Block>>>(blockNotifierProvider,
        (previous, next) {
      _blockState = next;
      state = AsyncValue.data(filterByBlock(_allNotifications));
    });

    return filteredNotifications;
  }

  void loadMore(List<Notification> notifications) {
    final filteredNotifications = filterByBlock(notifications);

    state.whenData((currentNotifications) {
      final updatedNotifications = List.of(currentNotifications)
        ..addAll(filteredNotifications);

      state = AsyncValue.data(updatedNotifications);
    });
  }

  void refresh(List<Notification> notifications) {
    state = AsyncValue.data(filterByBlock(notifications));
  }

  List<Notification> filterByBlock(List<Notification> notifications) {
    final myBlockList = _blockState.when(
      data: (blocks) => blocks,
      loading: () => <Block>[],
      error: (error, _) => <Block>[],
    );

    final blockedUserIds = myBlockList.map((block) => block.targetUid).toSet();

    return notifications
        .where(
            (notification) => !blockedUserIds.contains(notification.senderUid))
        .toList();
  }

  void markAsRead(Notification notification) {
    state.whenData((currentNotifications) {
      final updatedNotifications =
          currentNotifications.map((currentNotification) {
        if (currentNotification.id == notification.id) {
          return currentNotification.copyWith(isRead: true);
        } else {
          return currentNotification;
        }
      }).toList();

      state = AsyncValue.data(updatedNotifications);
    });
  }

  void deleteById(String notificationId) {
    state.whenData((currentNotifications) {
      final updatedNotifications = currentNotifications.where((notification) {
        return notification.id != notificationId;
      }).toList();

      state = AsyncValue.data(updatedNotifications);
    });
  }
}

final notificationNotifierProvider =
    AsyncNotifierProvider<NotificationNotifier, List<Notification>>(() {
  return NotificationNotifier();
});
