import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/widget/post_card.dart';
import 'package:green_heart/application/state/notification_detail_post_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';

class NotificationDetailPage extends ConsumerWidget {
  const NotificationDetailPage({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState =
        ref.watch(notificationDetailPostNotifierProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('通知の詳細'),
      ),
      body: postsState.when(
        data: (posts) {
          return posts.isEmpty
              ? const Center(child: Text('投稿がありません'))
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 0.h,
                        bottom: 8.h,
                        left: 8.w,
                        right: 8.w,
                      ),
                      child: PostCard(post: posts.first),
                    ),
                  ),
                );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, _) {
          return AsyncErrorWidget(
            error: error,
            retry: () => ref.refresh(
              notificationDetailPostNotifierProvider(postId),
            ),
          );
        },
      ),
    );
  }
}
