import 'package:green_heart/domain/type/comment.dart';

abstract class CommentRepository {
  Future<Comment> addComment(
    String uid,
    String postId,
    String content,
    String? parentCommentId,
    String userName,
    String? userImage,
  );
  Future<List<Comment>> getComments(String postId);
  Future<List<Comment>> getReplyComments(String postId, String parentCommentId);
  Future<int> deleteComment(String postId, String commentId);
  Future<void> deleteReplyComment(String postId, String commentId);
  Future<void> deleteAllCommentByUid(String uid);
}
