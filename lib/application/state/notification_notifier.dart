import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/notification_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/domain/type/notification.dart';
import 'package:green_heart/application/di/block_di.dart';

class NotificationNotifier extends AsyncNotifier<List<Notification>> {
  @override
  Future<List<Notification>> build() async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザー情報が取得できませんでした。再度お試しください。');
    }

    final notifications =
        await ref.read(notificationGetUsecaseProvider).execute(uid);
    final filteredNotifications = await filterByBlock(notifications);

    return filteredNotifications;
  }

  Future<void> loadMore(List<Notification> notifications) async {
    final filteredNotifications = await filterByBlock(notifications);

    state.whenData((currentNotifications) {
      final updatedNotifications = List.of(currentNotifications)
        ..addAll(filteredNotifications);

      state = AsyncValue.data(updatedNotifications);
    });
  }

  Future<void> refresh(List<Notification> notifications) async {
    state = await AsyncValue.guard(() async {
      return await filterByBlock(notifications);
    });
  }

  Future<List<Notification>> filterByBlock(
    List<Notification> notifications,
  ) async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザー情報が取得できませんでした。再度お試しください。');
    }

    final myBlockList = await ref.read(blockGetUsecaseProvider).execute(uid);
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
