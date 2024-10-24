import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/presentation/page/error_page.dart';
import 'package:green_heart/presentation/widget/loading_indicator.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';

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
        return ListTile(
          leading: CircleAvatar(
            radius: 24.r,
            backgroundImage: CachedNetworkImageProvider(
              comments[index].userProfile?.imageUrl ?? '',
            ),
          ),
          title: Row(
            children: [
              Text(
                comments[index].userProfile?.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          subtitle: Text(
            comments[index].comment.content,
            style: TextStyle(fontSize: 16.sp),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Icon(Icons.delete_outline, size: 20.sp),
                onTap: () async {
                  final result = await showConfirmationDialog(
                    context: context,
                    title: '確認',
                    content: 'コメントを削除しますか？',
                    positiveButtonText: '削除する',
                    negativeButtonText: 'キャンセル',
                  );
                  if (!result) return;

                  final commentId = comments[index].comment.id;
                  ref
                      .read(commentNotifierProvider(postId).notifier)
                      .deleteComment(commentId);
                },
              ),
              const SizedBox(height: 4),
              Text(
                DateUtil.formatCommentTime(comments[index].comment.createdAt),
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
        );
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
