import 'package:flutter/material.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/presentation/dialog/confirmation_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/domain/util/date_util.dart';

class CommentCard extends ConsumerWidget {
  const CommentCard({
    super.key,
    required this.commentData,
    required this.postId,
  });

  final CommentData commentData;
  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundImage: CachedNetworkImageProvider(
              commentData.profile?.imageUrl ?? '',
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      commentData.profile?.name ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      DateUtil.formatCommentTime(commentData.comment.createdAt),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  commentData.comment.content,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {},
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
                            .deleteComment(commentData.comment.id);
                      },
                      child: const Text('削除'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
