import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_heart/application/interface/comment_repository.dart';

class CommentDeleteAllUsecase {
  final CommentRepository _commentRepository;

  CommentDeleteAllUsecase(this._commentRepository);

  Future<void> execute(User user) {
    return _commentRepository.deleteAllCommentByUid(user.uid);
  }
}
