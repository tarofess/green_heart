import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/notification_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/widget/notification_card.dart';
import 'package:green_heart/application/di/notification_di.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/domain/type/notification.dart' as custom;
import 'package:green_heart/domain/type/result.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('通知'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // ignore: unused_result
          ref.refresh(notificationNotifierProvider);
        },
        child: notificationState.when(
          data: (notifications) {
            return notifications.isEmpty
                ? const CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text('新しい通知はありません'),
                        ),
                      ),
                    ],
                  )
                : _buildNotificationList(ref, notifications);
          },
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
          error: (e, stackTrace) {
            return AsyncErrorWidget(
              error: e,
              retry: () => ref.refresh(notificationNotifierProvider),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    WidgetRef ref,
    List<custom.Notification> notifications,
  ) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(notifications[index].id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          // iPhoneでの削除処理を想定
          onDismissed: (direction) async {
            if (direction == DismissDirection.endToStart) {
              await deleteNotification(
                context,
                ref,
                notifications[index],
              );
            }
          },
          child: GestureDetector(
            child: NotificationCard(notification: notifications[index]),
            onTap: () async {
              if (!notifications[index].isRead) {
                await LoadingOverlay.of(
                  context,
                  backgroundColor: Colors.white10,
                ).during(() => ref
                    .read(notificationMarkAsReadUsecaseProvider)
                    .execute(notifications[index]));
              }

              if (notifications[index].postId != null && context.mounted) {
                context.push(
                  '/notification_detail',
                  extra: {'postId': notifications[index].postId},
                );
              }
            },
            // Androidでの削除処理を想定
            onLongPress: () async {
              final isConfirmed = await showConfirmationDialog(
                context: context,
                title: '削除確認',
                content: 'この通知を削除しますか？',
                positiveButtonText: '削除',
                negativeButtonText: 'キャンセル',
              );

              if (!isConfirmed || !context.mounted) return;

              await deleteNotification(
                context,
                ref,
                notifications[index],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> deleteNotification(
    BuildContext context,
    WidgetRef ref,
    custom.Notification notification,
  ) async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) return;

    final result = await LoadingOverlay.of(
      context,
      backgroundColor: Colors.white10,
    ).during(() => ref
        .read(notificationDeleteUsecaseProvider)
        .execute(notification.id, uid));

    switch (result) {
      case Success():
        break;
      case Failure(message: final message):
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
        break;
    }
  }
}
