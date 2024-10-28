import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/application/state/comment_page_notifier.dart';

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
        _buildUserImage(),
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
              _buildComment(),
              SizedBox(height: 8.h),
              _buildActions(context, ref),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChildComment(
      BuildContext context, WidgetRef ref, Comment replyComment) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserImage(),
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
                _buildReplyComment(ref, replyComment),
                SizedBox(height: 8.h),
                _buildActions(context, ref, replyComment: replyComment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserImage() {
    return CircleAvatar(
      radius: 24.r,
      backgroundImage: CachedNetworkImageProvider(
        commentData.profile?.imageUrl ?? '',
      ),
    );
  }

  Widget _buildUserName() {
    return Text(
      commentData.profile?.name ?? '',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
    );
  }

  Widget _buildCommentedDate() {
    return Text(
      DateUtil.formatCommentTime(commentData.comment.createdAt),
      style: TextStyle(
        color: Colors.grey,
        fontSize: 14.sp,
      ),
    );
  }

  Widget _buildComment() {
    return Text(
      commentData.comment.content,
      style: TextStyle(
        fontSize: 14.sp,
      ),
    );
  }

  Widget _buildReplyComment(WidgetRef ref, Comment replyComment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              replyComment.content,
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
    WidgetRef ref, {
    Comment? replyComment,
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
        TextButton(
          onPressed: () async {
            final result = await showConfirmationDialog(
              context: context,
              title: '確認',
              content: 'コメントを削除しますか？',
              positiveButtonText: '削除する',
              negativeButtonText: 'キャンセル',
            );
            if (!result) return;

            await ref
                .read(commentNotifierProvider(postId).notifier)
                .deleteComment(
                  replyComment == null
                      ? commentData.comment.id
                      : replyComment.id,
                );
          },
          child: const Text('削除'),
        ),
      ],
    );
  }
}
