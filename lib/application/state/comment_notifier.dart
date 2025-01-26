import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/di/comment_di.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/application/state/post_manager_notifier.dart';
import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/application/state/profile_notifier.dart';

class CommentNotifier extends FamilyAsyncNotifier<List<CommentData>, String> {
  @override
  Future<List<CommentData>> build(String arg) async {
    final comments = await ref.read(commentGetUsecaseProvider).execute(arg);
    final filteredComments = await _filterBlockedComments(comments);
    return _createCommentDataList(filteredComments);
  }

  Future<List<CommentData>> _createCommentDataList(
    List<Comment> comments,
  ) async {
    return Future.wait(comments
        .where((comment) => comment.parentCommentId == null)
        .map((comment) => _createCommentData(comment)));
  }

  Future<CommentData> _createCommentData(Comment comment) async {
    final results = await Future.wait([
      ref.read(profileGetUsecaseProvider).execute(comment.uid),
      ref.read(commentGetReplyUsecaseProvider).execute(comment.id),
    ]);

    final profile = results[0] as Profile?;
    final replyComments = results[1] as List<Comment>;

    final replyCommentData = await Future.wait(
      replyComments.map((reply) => _createCommentData(reply)),
    );

    return CommentData(
      comment: comment,
      profile: profile,
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
        .where((comment) =>
            !blockList.any((block) => block.blockedUid == comment.uid))
        .toList();
  }

  void addComment(
    Comment newComment,
    PostData postData,
    String? parentCommentId,
  ) {
    final newCommentData = CommentData(
      comment: newComment,
      profile: ref.read(profileNotifierProvider).value,
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

    ref.read(postManagerNotifierProvider.notifier).addComment(
          newComment,
          postData,
        );
  }

  void deleteComment(String commentId) {
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

    ref.read(postManagerNotifierProvider.notifier).deleteComment(commentId);
  }
}

final commentNotifierProvider =
    AsyncNotifierProviderFamily<CommentNotifier, List<CommentData>, String>(
  CommentNotifier.new,
);
