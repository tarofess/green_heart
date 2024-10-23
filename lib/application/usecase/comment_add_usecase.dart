import 'package:green_heart/application/interface/comment_repository.dart';
import 'package:green_heart/domain/type/comment.dart';

class CommentAddUsecase {
  final CommentRepository _commentRepository;

  CommentAddUsecase(this._commentRepository);

  Future<Comment> execute(String uid, String postId, String content) async {
    return await _commentRepository.addComment(uid, postId, content);
  }
}
