import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/post_data.dart';

class PostManagerNotifier extends Notifier {
  @override
  void build() {}

  void toggleLike(PostData postData, String uid) {
    ref.read(userPostNotifierProvider(postData.post.uid).notifier).toggleLike(
          postData.post.id,
          uid,
        );
    ref.read(timelineNotifierProvider.notifier).toggleLike(
          postData.post.id,
          uid,
        );
  }

  void addComment(Comment newComment) {
    final uid = ref.watch(authStateProvider).value?.uid;
    ref.read(userPostNotifierProvider(uid).notifier).addComment(newComment);
    ref.read(timelineNotifierProvider.notifier).addComment(newComment);
  }

  void deleteComment(String commentId) {
    final uid = ref.watch(authStateProvider).value?.uid;
    ref.read(userPostNotifierProvider(uid).notifier).deleteComment(commentId);
    ref.read(timelineNotifierProvider.notifier).deleteComment(commentId);
  }
}

final postManagerNotifierProvider = NotifierProvider(
  () => PostManagerNotifier(),
);
