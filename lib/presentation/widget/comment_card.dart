import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

class CommentCard extends HookConsumerWidget {
  const CommentCard({
    super.key,
    required this.commentData,
    required this.postId,
    required this.focusNode,
  });

  final CommentData commentData;
  final String postId;
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
        _buildUserImage(CommentType.comment),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildUserName(),
                  SizedBox(width: 8.w),
                  _buildCommentedDate(),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                commentData.comment.content,
                style: TextStyle(fontSize: 14.sp),
              ),
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
          _buildUserImage(CommentType.reply, replyComment),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildUserName(replyComment),
                    SizedBox(width: 8.w),
                    _buildCommentedDate(replyComment),
                  ],
                ),
                SizedBox(height: 4.h),
                _buildReplyComment(ref, replyComment),
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

  Widget _buildUserImage(CommentType commentType, [CommentData? replyComment]) {
    if (commentType == CommentType.comment) {
      return commentData.profile?.imageUrl == null
          ? _buildEmptyImage()
          : CircleAvatar(
              radius: 24.r,
              backgroundImage: CachedNetworkImageProvider(
                commentData.profile?.imageUrl ?? '',
              ),
            );
    } else {
      return replyComment!.profile?.imageUrl == null
          ? _buildEmptyImage()
          : CircleAvatar(
              radius: 24.r,
              backgroundImage: CachedNetworkImageProvider(
                replyComment.profile?.imageUrl ?? '',
              ),
            );
    }
  }

  Widget _buildEmptyImage() {
    return CircleAvatar(
      radius: 24.r,
      backgroundColor: Colors.grey[200],
      child: Icon(
        Icons.person,
        size: 24.r,
        color: Colors.grey[500],
      ),
    );
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

  Widget _buildReplyComment(WidgetRef ref, CommentData replyComment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              replyComment.comment.content,
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ],
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
          child: const Text('返信する'),
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
        final result = await showConfirmationDialog(
          context: context,
          title: '確認',
          content: 'コメントを削除しますか？',
          positiveButtonText: '削除する',
          negativeButtonText: 'キャンセル',
        );
        if (!result) return;

        await ref.read(commentNotifierProvider(postId).notifier).deleteComment(
              replyComment == null
                  ? commentData.comment.id
                  : replyComment.comment.id,
            );
      },
      child: const Text('削除'),
    );
  }

  Widget _buildReportButton(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: const Text('通報'),
      onPressed: () async {
        try {
          final reportText = await showReportDialog(context);
          if (reportText == null) return;

          final uid = ref.watch(authStateProvider).value?.uid;
          if (uid == null) return;

          if (context.mounted) {
            await LoadingOverlay.of(context).during(
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
              const SnackBar(
                content: Text('コメントを通報しました。'),
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
    );
  }
}

enum CommentType {
  comment,
  reply,
}
