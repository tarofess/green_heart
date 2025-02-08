import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/presentation/widget/post_card.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/domain/type/post.dart';

class UserDiaryDetailPage extends ConsumerWidget {
  const UserDiaryDetailPage({super.key, required this.selectedPost});

  final Post selectedPost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPostState = ref.watch(
      userPostNotifierProvider(selectedPost.uid),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${selectedPost.releaseDate.year}年'
          '${selectedPost.releaseDate.month}月'
          '${selectedPost.releaseDate.day}日',
        ),
      ),
      body: SafeArea(
        child: userPostState.when(
          data: (userPosts) {
            final postData = userPosts.firstWhereOrNull(
              (posts) => posts.id == selectedPost.id,
            );
            return postData == null
                ? const Center(child: Text('データがありません'))
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 0.h,
                        bottom: 8.h,
                        left: 8.w,
                        right: 8.w,
                      ),
                      child: PostCard(post: postData),
                    ),
                  );
          },
          loading: () {
            return const Center(
              child: LoadingIndicator(message: '読み込み中'),
            );
          },
          error: (error, stackTrace) {
            return AsyncErrorWidget(
              error: error,
              retry: () =>
                  ref.refresh(userPostNotifierProvider(selectedPost.uid)),
            );
          },
        ),
      ),
    );
  }
}
