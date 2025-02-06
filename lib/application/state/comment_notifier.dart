import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/di/comment_di.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/application/state/post_manager_notifier.dart';
import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/domain/type/post.dart';

class CommentNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<CommentData>, String> {
  @override
  Future<List<CommentData>> build(String arg) async {
    final comments = await ref.read(commentGetUsecaseProvider).execute(arg);
    final filteredComments = await _filterBlockedComments(comments);
    return _createCommentDataList(filteredComments, arg);
  }

  Future<List<CommentData>> _createCommentDataList(
    List<Comment> comments,
    String postId,
  ) async {
    return Future.wait(comments
        .where((comment) => comment.parentCommentId == null)
        .map((comment) => _createCommentData(comment, postId)));
  }

  Future<CommentData> _createCommentData(Comment comment, String postId) async {
    final replyComments = await ref
        .read(commentGetReplyUsecaseProvider)
        .execute(postId, comment.id);

    final replyCommentData = await Future.wait(
      replyComments.map((reply) => _createCommentData(reply, postId)),
    );

    return CommentData(
      comment: comment,
      replyComments: replyCommentData,
      isMe: ref.watch(authStateProvider).value?.uid == comment.uid,
    );
  }

  Future<List<Comment>> _filterBlockedComments(List<Comment> comments) async {
    final currentUid = ref.watch(authStateProvider).value?.uid;
    if (currentUid == null) {
      throw Exception('ユーザー情報が取得できません。再度お試し下さい。');
    }

    final blockList =
        await ref.read(blockGetUsecaseProvider).execute(currentUid);
    return comments
        .where((comment) => !blockList.any((block) => block.uid == comment.uid))
        .toList();
  }

  void addComment(Comment newComment, String? parentCommentId, Post post) {
    final newCommentData = CommentData(
      comment: newComment,
      replyComments: [],
      isMe: true,
    );

    state = state.whenData((comments) {
      if (parentCommentId == null) {
        return [...comments, newCommentData];
      } else {
        return comments.map((commentData) {
          if (commentData.comment.id == parentCommentId) {
            return commentData.copyWith(
              replyComments: [...commentData.replyComments, newCommentData],
            );
          }
          return commentData;
        }).toList();
      }
    });

    ref.read(postManagerNotifierProvider.notifier).addComment(newComment, post);
  }

  void deleteComment(String postId, String commentId, int deletedCommentCount) {
    state = state.whenData((comments) => comments
        .map((commentData) {
          final updatedReplies = commentData.replyComments
              .where((reply) => reply.comment.id != commentId)
              .toList();

          if (commentData.comment.id == commentId) {
            return null;
          }

          return commentData.copyWith(replyComments: updatedReplies);
        })
        .whereType<CommentData>()
        .toList());

    ref.read(postManagerNotifierProvider.notifier).deleteComment(
          postId,
          deletedCommentCount,
        );
  }
}

final commentNotifierProvider = AutoDisposeAsyncNotifierProviderFamily<
    CommentNotifier, List<CommentData>, String>(
  CommentNotifier.new,
);
