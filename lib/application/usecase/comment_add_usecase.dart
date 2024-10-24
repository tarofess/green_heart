import 'package:green_heart/application/interface/comment_repository.dart';
import 'package:green_heart/application/state/comment_notifier.dart';
import 'package:green_heart/application/state/my_post_notifier.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';

class CommentAddUsecase {
  final CommentRepository _commentRepository;
  final MyPostNotifier _myPostNotifier;
  final TimelineNotifier _timelineNotifier;

  CommentAddUsecase(
    this._commentRepository,
    this._myPostNotifier,
    this._timelineNotifier,
  );

  Future<void> execute(String uid, String postId, String content,
      CommentNotifier commentNotifier) async {
    final newComment =
        await _commentRepository.addComment(uid, postId, content);

    commentNotifier.addComment(newComment);
    _myPostNotifier.updateCommentCount(postId);
    _timelineNotifier.updateCommentCount(postId);
  }
}
