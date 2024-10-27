import 'package:green_heart/application/interface/comment_repository.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';

class CommentAddUsecase {
  final CommentRepository _commentRepository;
  final UserPostNotifier _userPostNotifier;
  final TimelineNotifier _timelineNotifier;

  CommentAddUsecase(
    this._commentRepository,
    this._userPostNotifier,
    this._timelineNotifier,
  );

  Future<void> execute(
    String uid,
    String postId,
    String content,
    String? parentCommentId,
    CommentNotifier commentNotifier,
  ) async {
    final newComment = await _commentRepository.addComment(
      uid,
      postId,
      content,
      parentCommentId,
    );

    commentNotifier.addComment(newComment, parentCommentId);
    _userPostNotifier.addComment(newComment);
    _timelineNotifier.addComment(newComment);
  }
}
