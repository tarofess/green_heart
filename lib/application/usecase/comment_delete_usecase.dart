import 'package:green_heart/application/interface/comment_repository.dart';

class CommentDeleteUsecase {
  final CommentRepository _commentRepository;

  CommentDeleteUsecase(this._commentRepository);

  Future<void> execute(String commentId) async {
    await _commentRepository.deleteComment(commentId);
  }
}
