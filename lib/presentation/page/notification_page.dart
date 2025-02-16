import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: NotificationCard(
                          notification: notifications[index],
                        ),
                        onTap: () async {
                          if (notifications[index].isRead == false) {
                            // 未読の場合は既読にする
                            await LoadingOverlay.of(
                              context,
                              backgroundColor: Colors.white10,
                            ).during(
                              () => ref
                                  .read(notificationMarkAsReadUsecaseProvider)
                                  .execute(notifications[index]),
                            );
                          }

                          final postId = notifications[index].postId;
                          if (postId == null || !context.mounted) return;

                          context.push(
                            '/notification_detail',
                            extra: {'postId': postId},
                          );
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
