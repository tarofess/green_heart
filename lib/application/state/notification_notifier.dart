import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/notification_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/domain/type/notification.dart';
import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/domain/type/block.dart';
import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/application/usecase/block_get_by_other_usecase.dart';

class NotificationNotifier extends AsyncNotifier<List<Notification>> {
  late AsyncValue<List<Block>> _blockState;
  List<Notification> _allNotifications = [];
  late BlockGetByOtherUseCase _blockGetByOtherUsecase;

  @override
  Future<List<Notification>> build() async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザー情報が取得できませんでした。再度お試しください。');
    }

    _blockState = ref.read(blockNotifierProvider);
    _blockGetByOtherUsecase = ref.read(blockGetByOtherUsecaseProvider);

    final notifications =
        await ref.read(notificationGetUsecaseProvider).execute(uid);
    final filteredNotifications = await filterByBlock(notifications);

    // ブロックの状態変更で通知が変わるのに備えて全通知を保持しておく
    _allNotifications = filteredNotifications;

    // ブロック情報が更新された場合、保持している通知データに再度フィルターを適用する
    ref.listen<AsyncValue<List<Block>>>(blockNotifierProvider,
        (previous, next) async {
      _blockState = next;
      state = AsyncValue.data(await filterByBlock(_allNotifications));
    });

    return filteredNotifications;
  }

  Future<void> loadMore(List<Notification> notifications) async {
    final filteredNotifications = await filterByBlock(notifications);

    state.whenData((currentNotifications) {
      final updatedNotifications = [
        ...currentNotifications,
        ...filteredNotifications
      ];
      state = AsyncValue.data(updatedNotifications);
    });
  }

  Future<void> refresh(List<Notification> notifications) async {
    state = AsyncValue.data(await filterByBlock(notifications));
  }

  Future<List<Notification>> filterByBlock(
    List<Notification> notifications,
  ) async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザー情報が取得できませんでした。再度お試しください。');
    }

    // 自分がブロックしているユーザーのuidを取得
    final myBlockList = _blockState.when(
      data: (blocks) => blocks,
      loading: () => <Block>[],
      error: (error, _) => <Block>[],
    );
    final blockedUserIds = myBlockList.map((block) => block.targetUid).toSet();

    // 自分をブロックしているユーザーのuidを取得
    final blockMeList = await _blockGetByOtherUsecase.execute(uid);
    final blockMeUserIds = blockMeList.map((block) => block.uid).toSet();

    // 上記二つのuidを合算
    final allFilteredUserIds = blockedUserIds.union(blockMeUserIds);

    return notifications
        .where((notification) =>
            !allFilteredUserIds.contains(notification.senderUid))
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
