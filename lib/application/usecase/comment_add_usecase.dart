import 'package:green_heart/application/interface/comment_repository.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/domain/type/result.dart';

class CommentAddUsecase {
  final CommentRepository _commentRepository;

  CommentAddUsecase(this._commentRepository);

  Future<Result> execute(
    String uid,
    PostData postData,
    String content,
    String? parentCommentId,
    String userName,
    String? userImage,
    CommentNotifier commentNotifier,
  ) async {
    try {
      final newComment = await _commentRepository.addComment(
        uid,
        postData.post.id,
        content,
        parentCommentId,
        userName,
        userImage,
      );

      commentNotifier.addComment(newComment, postData, parentCommentId);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
