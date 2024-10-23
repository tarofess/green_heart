import 'package:green_heart/application/interface/comment_repository.dart';
import 'package:green_heart/domain/type/comment.dart';

class CommentGetUsecase {
  final CommentRepository _commentRepository;

  CommentGetUsecase(this._commentRepository);

  Future<List<Comment>> execute(String postId) {
    return _commentRepository.getComments(postId);
  }
}
