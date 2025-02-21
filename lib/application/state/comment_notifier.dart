import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/di/comment_di.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/application/state/post_manager_notifier.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/domain/type/block.dart';

class CommentNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<CommentData>, String> {
  late AsyncValue<List<Block>> _blockState;

  @override
  Future<List<CommentData>> build(String arg) async {
    _blockState = ref.watch(blockNotifierProvider);

    final comments = await ref.read(commentGetUsecaseProvider).execute(arg);
    final filteredComments = await _filterByBlock(comments);

    return _createCommentDataList(filteredComments);
  }

  Future<List<CommentData>> _createCommentDataList(
    List<Comment> comments,
  ) async {
    // 親コメントのみ抽出
    final parentComments =
        comments.where((comment) => comment.parentCommentId == null).toList();

    return Future.wait(
      parentComments.map(
        (comment) => _createCommentData(comment, comments),
      ),
    );
  }

  Future<CommentData> _createCommentData(
    Comment comment,
    List<Comment> allComments,
  ) async {
    // parentCommentId が comment.id のコメントを抽出
    final replyComments = allComments
        .where((reply) => reply.parentCommentId == comment.id)
        .toList();

    // 再帰的に _createCommentData を呼び出す
    final replyCommentData = await Future.wait(
      replyComments.map(
        (reply) => _createCommentData(reply, allComments),
      ),
    );

    return CommentData(
      comment: comment,
      replyComments: replyCommentData,
      isMe: ref.watch(authStateProvider).value?.uid == comment.uid,
    );
  }

  Future<List<Comment>> _filterByBlock(List<Comment> comments) async {
    final myBlockList = _blockState.when(
      data: (blocks) => blocks,
      loading: () => <Block>[],
      error: (error, _) => <Block>[],
    );

    final blockedUserIds = myBlockList.map((block) => block.targetUid).toSet();

    return comments
        .where((comment) => !blockedUserIds.contains(comment.uid))
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
