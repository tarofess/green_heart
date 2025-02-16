import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_page_state.freezed.dart';

@freezed
class CommentPageState with _$CommentPageState {
  const factory CommentPageState({
    @Default(false) bool isReplying,
    String? parentCommentId,
    String? replyTargetUid,
    String? replyTargetUserName,
  }) = _CommentPageState;
}
