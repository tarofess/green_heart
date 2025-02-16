import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/comment_page_state.dart';

class CommentPageNotifier extends Notifier<CommentPageState> {
  @override
  CommentPageState build() {
    return const CommentPageState();
  }

  void startReply(
    String parentId,
    String? replyTargetUid,
    String? replyTargetUserName,
  ) {
    state = state.copyWith(
      isReplying: true,
      parentCommentId: parentId,
      replyTargetUid: replyTargetUid,
      replyTargetUserName: replyTargetUserName,
    );
  }

  void cancelReply() {
    state = state.copyWith(
      isReplying: false,
      parentCommentId: null,
      replyTargetUid: null,
      replyTargetUserName: null,
    );
  }
}

final commentPageNotifierProvider =
    NotifierProvider<CommentPageNotifier, CommentPageState>(
  () => CommentPageNotifier(),
);
