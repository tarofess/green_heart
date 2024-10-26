import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/presentation/page/error_page.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/widget/comment_card.dart';

class CommentPage extends HookConsumerWidget {
  const CommentPage({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentState = ref.watch(commentNotifierProvider(postId));
    final commentTextController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('コメント')),
      body: commentState.when(
        data: (comments) {
          return Column(
            children: [
              Expanded(
                child: comments.isEmpty
                    ? _buildEmptyCommentMessage()
                    : _buildComment(ref, comments),
              ),
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.only(top: 8.r, bottom: 8.r, left: 16.r),
                child: _buildInputForm(ref, commentTextController),
              ),
            ],
          );
        },
        loading: () => const LoadingIndicator(),
        error: (e, st) => ErrorPage(
          error: e,
          retry: () => ref.refresh(commentNotifierProvider(postId)),
        ),
      ),
    );
  }

  Widget _buildEmptyCommentMessage() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'コメントはまだありません',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.sp),
            Text(
              '最初のコメントを追加してみよう。',
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComment(WidgetRef ref, List<CommentData> comments) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return CommentCard(commentData: comments[index], postId: postId);
      },
    );
  }

  Widget _buildInputForm(
      WidgetRef ref, TextEditingController commentTextController) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: commentTextController,
            decoration: InputDecoration(
              hintText: 'コメントを入力...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
            ),
          ),
        ),
        IconButton(
            icon: Icon(Icons.send, size: 24.sp),
            onPressed: () async {
              final uid = ref.read(authStateProvider).value?.uid;
              if (uid == null || commentTextController.text.isEmpty) {
                return;
              }

              await ref.read(commentAddUsecaseProvider).execute(
                    uid,
                    postId,
                    commentTextController.text,
                    ref.read(commentNotifierProvider(postId).notifier),
                  );
              commentTextController.clear();
            }),
      ],
    );
  }
}
