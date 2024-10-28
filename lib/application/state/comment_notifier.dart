import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';

class CommentNotifier extends FamilyAsyncNotifier<List<CommentData>, String> {
  @override
  Future<List<CommentData>> build(String arg) async {
    final comments = await ref.read(commentGetUsecaseProvider).execute(arg);
    final commentDataList = <CommentData>[];
    for (final comment in comments) {
      if (comment.parentCommentId != null) {
        continue;
      }
      final profile = await ref.read(profileGetUsecaseProvider).execute(
            comment.uid,
          );
      final replyComments =
          await ref.read(commentGetReplyUsecaseProvider).execute(comment.id);

      commentDataList.add(CommentData(
        comment: comment,
        profile: profile,
        replyComments: replyComments,
      ));
    }
    return commentDataList;
  }

  Future<void> addComment(Comment newComment, String? parentCommentId) async {
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
      state = AsyncValue.data(state.value?.map((commentData) {
            if (commentData.comment.id == parentCommentId) {
              return commentData.copyWith(
                replyComments: [
                  ...commentData.replyComments,
                  updatedComment,
                ],
              );
            }
            return commentData;
          }).toList() ??
          []);
    }
  }

  Future<void> deleteComment(String commentId) async {
    await ref.read(commentDeleteUsecaseProvider).execute(commentId);
    ref
        .read(userPostNotifierProvider(ref.watch(authStateProvider).value?.uid)
            .notifier)
        .deleteComment(commentId);
    ref.read(timelineNotifierProvider.notifier).deleteComment(commentId);

    state = AsyncValue.data(
      state.value
              ?.map((commentData) {
                if (commentData.comment.id == commentId) {
                  return null;
                }
                final updatedReplies = commentData.replyComments
                    .where((reply) => reply.id != commentId)
                    .toList();

                if (updatedReplies.length != commentData.replyComments.length) {
                  return commentData.copyWith(replyComments: updatedReplies);
                }
                return commentData;
              })
              .where((commentData) => commentData != null)
              .map((commentData) => commentData!)
              .toList() ??
          [],
    );
  }
}

final commentNotifierProvider =
    AsyncNotifierProviderFamily<CommentNotifier, List<CommentData>, String>(
        CommentNotifier.new);
