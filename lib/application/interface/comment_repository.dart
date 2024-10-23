import 'package:green_heart/domain/type/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getComments(String postId);
  Future<Comment> addComment(String uid, String postId, String content);
  Future<void> deleteComment(String commentId);
}
