import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/application/state/comment_page_notifier.dart';
import 'package:green_heart/application/di/report_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/presentation/dialog/error_dialog.dart';
import 'package:green_heart/presentation/dialog/report_dialog.dart';
import 'package:green_heart/presentation/widget/loading_overlay.dart';
import 'package:green_heart/presentation/widget/user_empty_image.dart';
import 'package:green_heart/presentation/widget/user_firebase_image.dart';
import 'package:green_heart/application/di/comment_di.dart';
import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/domain/type/post.dart';

class CommentCard extends HookConsumerWidget {
  const CommentCard({
    super.key,
    required this.commentData,
    required this.post,
    required this.focusNode,
  });

  final CommentData commentData;
  final Post post;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildParentComment(context, ref),
          ...commentData.replyComments.map((replyComment) {
            return _buildChildComment(context, ref, replyComment);
          }),
        ],
      ),
    );
  }

  Widget _buildParentComment(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserImage(context, ref),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildUserName()),
                  SizedBox(width: 8.w),
                  _buildCommentedDate(),
                ],
              ),
              SizedBox(height: 8.h),
              _buildCommentText(commentData.comment.content),
              SizedBox(height: 4.h),
              _buildActions(context, ref),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChildComment(
    BuildContext context,
    WidgetRef ref,
    CommentData replyComment,
  ) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, top: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserImage(context, ref, replyComment),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildUserName(replyComment),
                    ),
                    SizedBox(width: 8.w),
                    _buildCommentedDate(replyComment),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildCommentText(replyComment.comment.content),
                SizedBox(height: 4.h),
                _buildActions(context, ref, replyComment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentText(String comment) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Text(comment),
    );
  }

  Widget _buildUserImage(
    BuildContext context,
    WidgetRef ref, [
    CommentData? replyComment,
  ]) {
    if (replyComment == null) {
      return GestureDetector(
        onTap: () {
          final uid = ref.watch(authStateProvider).value?.uid;
          if (post.uid != uid && commentData.comment.uid != uid) {
            context.push('/user', extra: {'uid': commentData.comment.uid});
          }
        },
        child: commentData.comment.userImage == null
            ? const UserEmptyImage(radius: 24)
            : UserFirebaseImage(
                imageUrl: commentData.comment.userImage,
                radius: 48,
              ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          context.push('/user', extra: {'uid': replyComment.comment.uid});
        },
        child: replyComment.comment.userImage == null
            ? const UserEmptyImage(radius: 24)
            : UserFirebaseImage(
                imageUrl: replyComment.comment.userImage,
                radius: 48,
              ),
      );
    }
  }

  Widget _buildUserName([CommentData? replyComment]) {
    return Text(
      replyComment == null
          ? commentData.comment.userName
          : replyComment.comment.userName,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCommentedDate([CommentData? replyComment]) {
    return Text(
      DateUtil.formatCommentTime(
        replyComment == null
            ? commentData.comment.createdAt
            : replyComment.comment.createdAt,
      ),
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildActions(
    BuildContext context,
    WidgetRef ref, [
    CommentData? replyComment,
  ]) {
    return Row(
      children: [
        _buildReplyButton(context, ref, replyComment),
        if (replyComment == null && commentData.isMe)
          _buildDeleteButton(context, ref)
        else if (replyComment != null && replyComment.isMe)
          _buildDeleteButton(context, ref, replyComment)
        else
          _buildReportButton(context, ref),
      ],
    );
  }

  Widget _buildReplyButton(
    BuildContext context,
    WidgetRef ref, [
    CommentData? replyComment,
  ]) {
    return TextButton(
      child: const Text(
        '返信する',
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
      onPressed: () {
        ref.read(commentPageNotifierProvider.notifier).startReply(
              commentData.comment.id,
              replyComment == null
                  ? commentData.comment.uid
                  : replyComment.comment.uid,
              replyComment == null
                  ? commentData.comment.userName
                  : replyComment.comment.userName,
            );
        focusNode.requestFocus();
      },
    );
  }

  Widget _buildDeleteButton(
    BuildContext context,
    WidgetRef ref, [
    CommentData? replyComment,
  ]) {
    return TextButton(
      child: const Text(
        '削除',
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
      onPressed: () async {
        final isConfirmed = await showConfirmationDialog(
          context: context,
          title: '確認',
          content: 'コメントを削除しますか？',
          positiveButtonText: '削除する',
          negativeButtonText: 'キャンセル',
        );
        if (!isConfirmed) return;

        if (context.mounted) {
          final result = await LoadingOverlay.of(
            context,
            backgroundColor: Colors.white10,
          ).during(() {
            final commentId = replyComment == null
                ? commentData.comment.id
                : replyComment.comment.id;

            return ref.read(commentDeleteUsecaseProvider).execute(
                  post.id,
                  commentId,
                  ref.read(commentNotifierProvider(post.id).notifier),
                );
          });

          switch (result) {
            case Success():
              break;
            case Failure(message: final message):
              if (context.mounted) {
                showErrorDialog(
                  context: context,
                  title: 'コメント削除エラー',
                  content: message,
                );
              }
              break;
          }
        }
      },
    );
  }

  Widget _buildReportButton(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: const Text(
        '通報',
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
      onPressed: () async {
        final reportText = await showReportDialog(context);
        if (reportText == null) return;

        final uid = ref.watch(authStateProvider).value?.uid;
        if (uid == null) return;

        if (context.mounted) {
          final result = await LoadingOverlay.of(
            context,
            backgroundColor: Colors.white10,
          ).during(
            () => ref.read(reportAddUsecaseProvider).execute(
                  uid,
                  reportText,
                  reportedPostId: null,
                  reportedCommentId: commentData.comment.id,
                  reportedUserId: null,
                ),
          );

          switch (result) {
            case Success():
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('コメントを通報しました。')),
                );
              }
              break;
            case Failure(message: final message):
              if (context.mounted) {
                showErrorDialog(
                  context: context,
                  title: '通報エラー',
                  content: message,
                );
              }
              break;
          }
        }
      },
    );
  }
}
