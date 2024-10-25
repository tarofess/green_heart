import 'package:green_heart/application/interface/comment_repository.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';

class CommentAddUsecase {
  final CommentRepository _commentRepository;
  final UserPostNotifier _myPostNotifier;

  CommentAddUsecase(
    this._commentRepository,
    this._myPostNotifier,
  );

  Future<void> execute(String uid, String postId, String content,
      CommentNotifier commentNotifier) async {
    final newComment =
        await _commentRepository.addComment(uid, postId, content);

    commentNotifier.addComment(newComment);
    _myPostNotifier.updateCommentCount(postId);
  }
}
