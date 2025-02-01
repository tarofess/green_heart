import 'package:green_heart/application/interface/comment_repository.dart';
import 'package:green_heart/domain/type/comment.dart';

class CommentGetReplyUsecase {
  final CommentRepository _commentRepository;

  CommentGetReplyUsecase(this._commentRepository);

  Future<List<Comment>> execute(String postId, String parentCommentId) {
    return _commentRepository.getReplyComments(postId, parentCommentId);
  }
}
