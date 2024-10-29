import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/comment_page_state.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/comment_notifier.dart';

class CommentPageNotifier extends Notifier<CommentPageState> {
  @override
  CommentPageState build() {
    return const CommentPageState();
  }

  void startReply(String parentId, String? parentUserName) {
    state = state.copyWith(
      isReplying: true,
      parentCommentId: parentId,
      parentUserName: parentUserName,
    );
  }

  void cancelReply() {
    state = state.copyWith(
      isReplying: false,
      parentCommentId: null,
      parentUserName: null,
    );
  }

  Future<void> submitComment(
    TextEditingController commentTextController,
    FocusNode focusNode,
    String postId,
  ) async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null || commentTextController.text.isEmpty) {
      return;
    }

    await ref.read(commentNotifierProvider(postId).notifier).addComment(
          uid,
          postId,
          commentTextController.text,
          ref.read(commentPageNotifierProvider.notifier).state.parentCommentId,
        );

    commentTextController.clear();
    focusNode.unfocus();
    ref.read(commentPageNotifierProvider.notifier).cancelReply();
  }
}

final commentPageNotifierProvider =
    NotifierProvider<CommentPageNotifier, CommentPageState>(
  () => CommentPageNotifier(),
);
