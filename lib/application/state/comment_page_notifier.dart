import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/comment_page_state.dart';

class CommentPageNotifier extends Notifier<CommentPageState> {
  @override
  CommentPageState build() {
    return const CommentPageState();
  }

  void startReply(String parentId) {
    state = state.copyWith(
      isReplying: true,
      parentCommentId: parentId,
    );
  }

  void cancelReply() {
    state = state.copyWith(
      isReplying: false,
      parentCommentId: null,
    );
  }
}

final commentPageNotifierProvider =
    NotifierProvider<CommentPageNotifier, CommentPageState>(
  () => CommentPageNotifier(),
);
