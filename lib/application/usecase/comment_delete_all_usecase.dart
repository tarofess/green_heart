import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/comment_repository.dart';

class CommentDeleteAllUsecase {
  final CommentRepository _commentRepository;

  CommentDeleteAllUsecase(this._commentRepository);

  Future<void> execute(User user) async {
    try {
      return await _commentRepository.deleteAllCommentByUid(user.uid);
    } catch (e) {
      throw AppException('コメントの削除に失敗しました。再度お試しください。');
    }
  }
}
