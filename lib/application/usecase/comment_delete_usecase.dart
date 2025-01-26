import 'package:green_heart/application/interface/comment_repository.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/domain/type/result.dart';

class CommentDeleteUsecase {
  final CommentRepository _commentRepository;

  CommentDeleteUsecase(this._commentRepository);

  Future<Result> execute(
    String commentId,
    CommentNotifier commentNotifier,
  ) async {
    try {
      await _commentRepository.deleteComment(commentId);
      commentNotifier.deleteComment(commentId);
      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
