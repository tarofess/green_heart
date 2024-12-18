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
import 'package:green_heart/domain/type/post_data.dart';

class CommentCard extends HookConsumerWidget {
  const CommentCard({
    super.key,
    required this.commentData,
    required this.postData,
    required this.focusNode,
  });

  final CommentData commentData;
  final PostData postData;
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
        _buildUserImage(context, CommentType.comment),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildUserName(),
                  ),
                  SizedBox(width: 8.w),
                  _buildCommentedDate(),
                ],
              ),
              SizedBox(height: 4.h),
              _buildCommentText(commentData.comment.content),
              SizedBox(height: 8.h),
              _buildActions(context, ref, CommentType.comment),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChildComment(
      BuildContext context, WidgetRef ref, CommentData replyComment) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserImage(context, CommentType.reply, replyComment),
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
                SizedBox(height: 4.h),
                _buildCommentText(replyComment.comment.content),
                SizedBox(height: 8.h),
                _buildActions(
                  context,
                  ref,
                  CommentType.reply,
                  replyComment: replyComment,
                ),
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
      child: Text(
        comment,
        style: TextStyle(fontSize: 14.sp),
      ),
    );
  }

  Widget _buildUserImage(
    BuildContext context,
    CommentType commentType, [
    CommentData? replyComment,
  ]) {
    if (commentType == CommentType.comment) {
      return GestureDetector(
        onTap: () {
          context.push('/user', extra: {'uid': commentData.comment.uid});
        },
        child: commentData.profile?.imageUrl == null
            ? const UserEmptyImage(radius: 24)
            : UserFirebaseImage(
                imageUrl: commentData.profile?.imageUrl,
                radius: 48,
              ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          context.push('/user', extra: {'uid': replyComment.comment.uid});
        },
        child: replyComment!.profile?.imageUrl == null
            ? const UserEmptyImage(radius: 24)
            : UserFirebaseImage(
                imageUrl: replyComment.profile?.imageUrl,
                radius: 48,
              ),
      );
    }
  }

  Widget _buildUserName([CommentData? replyComment]) {
    return Text(
      replyComment == null
          ? commentData.profile?.name ?? ''
          : replyComment.profile?.name ?? '',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildCommentedDate([CommentData? replyComment]) {
    return Text(
      DateUtil.formatCommentTime(
        replyComment == null
            ? commentData.comment.createdAt
            : replyComment.comment.createdAt,
      ),
      style: TextStyle(
        color: Colors.grey,
        fontSize: 14.sp,
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    CommentType commentType, {
    CommentData? replyComment,
  }) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            ref.read(commentPageNotifierProvider.notifier).startReply(
                  commentData.comment.id,
                  commentData.profile?.name,
                );
            focusNode.requestFocus();
          },
          child: Text(
            '返信する',
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
        if (commentType == CommentType.comment && commentData.isMe)
          _buildDeleteButton(context, ref)
        else if (commentType == CommentType.reply && replyComment!.isMe)
          _buildDeleteButton(context, ref, replyComment)
        else
          _buildReportButton(context, ref),
      ],
    );
  }

  Widget _buildDeleteButton(
    BuildContext context,
    WidgetRef ref, [
    CommentData? replyComment,
  ]) {
    return TextButton(
      onPressed: () async {
        try {
          final result = await showConfirmationDialog(
            context: context,
            title: '確認',
            content: 'コメントを削除しますか？',
            positiveButtonText: '削除する',
            negativeButtonText: 'キャンセル',
          );
          if (!result) return;

          if (context.mounted) {
            await LoadingOverlay.of(
              context,
              backgroundColor: Colors.white10,
            ).during(
              () => ref
                  .read(commentNotifierProvider(postData.post.id).notifier)
                  .deleteComment(
                    replyComment == null
                        ? commentData.comment.id
                        : replyComment.comment.id,
                  ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            showErrorDialog(
              context: context,
              title: 'コメント削除エラー',
              content: e.toString(),
            );
          }
        }
      },
      child: Text(
        '削除',
        style: TextStyle(fontSize: 14.sp),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        try {
          final reportText = await showReportDialog(context);
          if (reportText == null) return;

          final uid = ref.watch(authStateProvider).value?.uid;
          if (uid == null) return;

          if (context.mounted) {
            await LoadingOverlay.of(
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
          }

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'コメントを通報しました。',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            showErrorDialog(
              context: context,
              title: '通報エラー',
              content: e.toString(),
            );
          }
        }
      },
      child: Text('通報', style: TextStyle(fontSize: 14.sp)),
    );
  }
}

enum CommentType {
  comment,
  reply,
}
