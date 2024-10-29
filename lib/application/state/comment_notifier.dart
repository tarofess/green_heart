import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/application/state/comment_page_notifier.dart';

class CommentNotifier extends FamilyAsyncNotifier<List<CommentData>, String> {
  @override
  Future<List<CommentData>> build(String arg) async {
    final commentDataList = await createCommentDataList(arg);
    return commentDataList;
  }

  Future<List<CommentData>> createCommentDataList(String postId) async {
    final commentDataList = <CommentData>[];

    final comments = await ref.read(commentGetUsecaseProvider).execute(postId);
    for (final comment in comments) {
      if (comment.parentCommentId != null) {
        continue;
      }
      final profile = await ref.read(profileGetUsecaseProvider).execute(
            comment.uid,
          );
      final isMe = ref.watch(authStateProvider).value?.uid == comment.uid;
      final replyComments =
          await ref.read(commentGetReplyUsecaseProvider).execute(comment.id);

      final replyCommentData = <CommentData>[];
      for (final relpyComment in replyComments) {
        final replyProfile = await ref.read(profileGetUsecaseProvider).execute(
              relpyComment.uid,
            );
        final isMe =
            ref.watch(authStateProvider).value?.uid == relpyComment.uid;
        replyCommentData.add(CommentData(
          comment: relpyComment,
          profile: replyProfile,
          replyComments: [],
          isMe: isMe,
        ));
      }

      commentDataList.add(CommentData(
        comment: comment,
        profile: profile,
        replyComments: replyCommentData,
        isMe: isMe,
      ));
    }

    return commentDataList;
  }

  Future<void> addComment(
    String uid,
    String postId,
    String comment,
    String? parentCommentId,
  ) async {
    final newComment = await ref.read(commentAddUsecaseProvider).execute(
          uid,
          postId,
          comment,
          ref.read(commentPageNotifierProvider).parentCommentId,
        );

    final userProfile =
        await ref.read(profileGetUsecaseProvider).execute(newComment.uid);

    if (parentCommentId == null) {
      final newCommentData = CommentData(
        comment: newComment,
        profile: userProfile,
        replyComments: [],
      );
      state = AsyncValue.data([...state.value ?? [], newCommentData]);
    } else {
      final updatedComment = newComment.copyWith(
        parentCommentId: parentCommentId,
      );
      final updatedCommentData = CommentData(
        comment: updatedComment,
        profile: userProfile,
        replyComments: [],
      );
      state = AsyncValue.data(state.value?.map((commentData) {
            if (commentData.comment.id == parentCommentId) {
              return commentData.copyWith(
                replyComments: [
                  ...commentData.replyComments,
                  updatedCommentData,
                ],
              );
            }
            return commentData;
          }).toList() ??
          []);
    }

    ref
        .read(userPostNotifierProvider(ref.watch(authStateProvider).value?.uid)
            .notifier)
        .addComment(newComment);
    ref.read(timelineNotifierProvider.notifier).addComment(newComment);
  }

  Future<void> deleteComment(String commentId) async {
    await ref.read(commentDeleteUsecaseProvider).execute(commentId);

    state = AsyncValue.data(
      state.value
              ?.map((commentData) {
                if (commentData.comment.id == commentId) {
                  return null;
                }

                final updatedReplies = commentData.replyComments
                    .where((reply) => reply.comment.id != commentId)
                    .toList();
                return commentData.copyWith(replyComments: updatedReplies);
              })
              .whereType<CommentData>()
              .toList() ??
          [],
    );

    ref
        .read(userPostNotifierProvider(ref.watch(authStateProvider).value?.uid)
            .notifier)
        .deleteComment(commentId);
    ref.read(timelineNotifierProvider.notifier).deleteComment(commentId);
  }
}

final commentNotifierProvider =
    AsyncNotifierProviderFamily<CommentNotifier, List<CommentData>, String>(
        CommentNotifier.new);
