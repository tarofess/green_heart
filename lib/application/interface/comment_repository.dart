import 'package:green_heart/domain/type/comment.dart';

abstract class CommentRepository {
  Future<Comment> addComment(
    String uid,
    String postId,
    String content,
    String? parentCommentId,
    String? replyTargetUid,
    String userName,
    String? userImage,
  );
  Future<List<Comment>> getComments(String postId);
  Future<int> deleteComment(String postId, String commentId);
  Future<void> deleteReplyComment(String postId, String commentId);
}
