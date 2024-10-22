import 'package:green_heart/domain/type/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getComments(String postId);
  Future<void> addComment(Comment comment);
  Future<void> deleteComment(String commentId);
}
