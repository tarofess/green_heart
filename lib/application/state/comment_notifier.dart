import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/comment_page_notifier.dart';
import 'package:green_heart/application/di/comment_di.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/application/state/post_manager_notifier.dart';

class CommentNotifier extends FamilyAsyncNotifier<List<CommentData>, String> {
  @override
  Future<List<CommentData>> build(String arg) async {
    final comments = await ref.read(commentGetUsecaseProvider).execute(arg);
    final commentDataList = await _createCommentDataList(comments);
    return commentDataList;
  }

  Future<List<CommentData>> _createCommentDataList(
    List<Comment> comments,
  ) async {
    List<CommentData> commentDataList = [];

    final commentFutures = comments
        .where((comment) => comment.parentCommentId == null)
        .map((comment) async {
      final results = await Future.wait([
        ref.read(profileGetUsecaseProvider).execute(comment.uid),
        ref.read(commentGetReplyUsecaseProvider).execute(comment.id),
      ]);
      final profile = results[0] as Profile?;
      final replyComments = results[1] as List<Comment>;
      final isMe = ref.watch(authStateProvider).value?.uid == comment.uid;

      final replyCommentFuture = replyComments.map((relpyComment) async {
        final replyProfile =
            await ref.read(profileGetUsecaseProvider).execute(relpyComment.uid);
        final isMe =
            ref.watch(authStateProvider).value?.uid == relpyComment.uid;
        return CommentData(
          comment: relpyComment,
          profile: replyProfile,
          replyComments: [],
          isMe: isMe,
        );
      });

      final replyCommentData = await Future.wait(replyCommentFuture);
      return CommentData(
        comment: comment,
        profile: profile,
        replyComments: replyCommentData,
        isMe: isMe,
      );
    });

    commentDataList = await Future.wait(commentFutures);
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
      // 新規コメント
      final newCommentData = CommentData(
        comment: newComment,
        profile: userProfile,
        replyComments: [],
        isMe: true,
      );
      state.whenData((comments) {
        state = AsyncValue.data([...comments, newCommentData]);
      });
    } else {
      // 返信コメント
      final updatedComment = newComment.copyWith(
        parentCommentId: parentCommentId,
      );
      final updatedCommentData = CommentData(
        comment: updatedComment,
        profile: userProfile,
        replyComments: [],
        isMe: true,
      );
      state.whenData((comments) {
        final updatedComment = comments.map((commentData) {
          if (commentData.comment.id == parentCommentId) {
            return commentData.copyWith(
              replyComments: [
                ...commentData.replyComments,
                updatedCommentData,
              ],
            );
          }
          return commentData;
        }).toList();

        state = AsyncValue.data(updatedComment);
      });
    }

    ref.read(postManagerNotifierProvider.notifier).addComment(newComment);
  }

  Future<void> deleteComment(String commentId) async {
    await ref.read(commentDeleteUsecaseProvider).execute(commentId);

    state.whenData((comments) {
      final updatedCommentData = comments
          .map((commentData) {
            if (commentData.comment.id == commentId) {
              return null;
            }

            final updatedReplies = commentData.replyComments
                .where((reply) => reply.comment.id != commentId)
                .toList();
            return commentData.copyWith(replyComments: updatedReplies);
          })
          .whereType<CommentData>()
          .toList();
      state = AsyncValue.data(updatedCommentData);
    });

    ref.read(postManagerNotifierProvider.notifier).deleteComment(commentId);
  }
}

final commentNotifierProvider =
    AsyncNotifierProviderFamily<CommentNotifier, List<CommentData>, String>(
        CommentNotifier.new);
