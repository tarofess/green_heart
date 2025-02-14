import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/notification_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/widget/notification_card.dart';
import 'package:green_heart/application/di/notification_di.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';

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
                ? const Center(child: Text('新しい通知はありません'))
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: NotificationCard(
                          notification: notifications[index],
                        ),
                        onTap: () async {
                          // 未読の場合は既読にする
                          if (notifications[index].isRead == false) {
                            LoadingOverlay.of(
                              context,
                              message: '読み込み中',
                              backgroundColor: Colors.white10,
                            ).during(
                              () => ref
                                  .read(notificationMarkAsReadUsecaseProvider)
                                  .execute(notifications[index]),
                            );
                          }

                          // postを取得して通知詳細画面に遷移
                          // context.push('/notification_detail', extra: {
                          //   'post': post,
                          // });
                        },
                      );
                    },
                  );
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
}
