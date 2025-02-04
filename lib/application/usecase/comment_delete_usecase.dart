import 'package:green_heart/application/interface/comment_repository.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/domain/type/result.dart';

class CommentDeleteUsecase {
  final CommentRepository _commentRepository;

  CommentDeleteUsecase(this._commentRepository);

  Future<Result> execute(
    String postId,
    String commentId,
    CommentNotifier commentNotifier,
  ) async {
    try {
      final deletedCommentsCount = await _commentRepository.deleteComment(
        postId,
        commentId,
      );

      commentNotifier.deleteComment(postId, commentId, deletedCommentsCount);
      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
