import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:green_heart/application/state/notification_scroll_state_notifier.dart';

class NotificationPage extends HookConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationNotifierProvider);
    final isLoadingMore = useState(false);
    final scrollController = useScrollController();

    useEffect(() {
      // 無限スクロールのための読み込み処理
      void onScroll() async {
        if (isLoadingMore.value) return;

        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          isLoadingMore.value = true;

          final result =
              await ref.read(notificationLoadMoreUsecaseProvider).execute();

          if (result is Failure && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('データの読み込みに失敗しました。再度お試しください。')),
            );
          }

          isLoadingMore.value = false;
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('通知'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final result =
              await ref.read(notificationRefreshUsecaseProvider).execute();

          if (result is Failure && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('データの読み込みに失敗しました。再度お試しください。')),
            );
          }
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
                : _buildNotificationList(ref, scrollController, notifications);
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
    ScrollController scrollController,
    List<custom.Notification> notifications,
  ) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: scrollController,
      itemCount: notifications.length + 1,
      itemBuilder: (context, index) {
        if (index < notifications.length) {
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

                if (!context.mounted) return;

                // フォローの通知の場合はユーザー画面に遷移
                if (notifications[index].type == 'follow') {
                  context.push(
                    '/user',
                    extra: {'uid': notifications[index].senderUid},
                  );
                } else {
                  // いいねとコメントの通知の場合は投稿詳細画面に遷移
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
        } else {
          return ref.read(notificationScrollStateNotifierProvider).hasMore
              ? Padding(
                  padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox.shrink();
        }
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
