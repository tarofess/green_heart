import 'package:green_heart/application/interface/comment_repository.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/result.dart';

class CommentAddUsecase {
  final CommentRepository _commentRepository;

  CommentAddUsecase(this._commentRepository);

  Future<Result> execute(
    String uid,
    Post post,
    String content,
    String? parentCommentId,
    String? replyTargetUid,
    String userName,
    String? userImage,
    CommentNotifier commentNotifier,
  ) async {
    try {
      final newComment = await _commentRepository.addComment(
        uid,
        post.id,
        content,
        parentCommentId,
        replyTargetUid,
        userName,
        userImage,
      );

      commentNotifier.addComment(newComment, parentCommentId, post);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
