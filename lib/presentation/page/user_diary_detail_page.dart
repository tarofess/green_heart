import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/presentation/widget/post_card.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/presentation/widget/async_error_widget.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';

class UserDiaryDetailPage extends ConsumerWidget {
  const UserDiaryDetailPage({super.key, required this.selectedPostData});

  final PostData selectedPostData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPostState = ref.watch(
      userPostNotifierProvider(selectedPostData.post.uid),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${selectedPostData.post.releaseDate.year}年'
          '${selectedPostData.post.releaseDate.month}月'
          '${selectedPostData.post.releaseDate.day}日',
          style: TextStyle(fontSize: 21.sp),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: userPostState.when(
            data: (userPosts) {
              final postData = userPosts.firstWhere(
                (posts) => posts.post.id == selectedPostData.post.id,
              );
              return Padding(
                padding: EdgeInsets.only(
                    top: 0.h, bottom: 8.h, left: 8.w, right: 8.w),
                child: PostCard(postData: postData),
              );
            },
            loading: () => const Center(
              child: LoadingIndicator(
                message: '読み込み中',
                backgroundColor: Colors.white10,
              ),
            ),
            error: (error, stackTrace) => AsyncErrorWidget(
              error: error,
              retry: () => ref
                  .refresh(userPostNotifierProvider(selectedPostData.post.uid)),
            ),
          ),
        ),
      ),
    );
  }
}
