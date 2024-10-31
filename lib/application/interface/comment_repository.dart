import 'package:green_heart/domain/type/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getComments(String postId);
  Future<List<Comment>> getReplyComments(String parentCommentId);
  Future<Comment> addComment(
      String uid, String postId, String content, String? parentCommentId);
  Future<void> deleteComment(String commentId);
  Future<void> deleteAllCommentByUid(String uid);
}
