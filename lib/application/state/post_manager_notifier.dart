import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/application/state/search_post_notifier.dart';

class PostManagerNotifier extends Notifier {
  @override
  void build() {}

  void deletePost(String uid, PostData postData) {
    ref.read(userPostNotifierProvider(uid).notifier).deletePost(
          postData.post.id,
        );
    ref.read(timelineNotifierProvider.notifier).deletePost(
          postData.post.id,
        );
    ref.read(searchPostNotifierProvider.notifier).deletePost(
          postData.post.id,
        );
  }

  void toggleLike(PostData postData, String uid) {
    ref.read(userPostNotifierProvider(postData.post.uid).notifier).toggleLike(
          postData.post.id,
          uid,
        );
    ref.read(timelineNotifierProvider.notifier).toggleLike(
          postData.post.id,
          uid,
        );
    ref.read(searchPostNotifierProvider.notifier).toggleLike(
          postData.post.id,
          uid,
        );
  }

  void addComment(Comment newComment, PostData postData) {
    final myUid = ref.watch(authStateProvider).value?.uid;
    if (postData.post.uid == myUid) {
      ref.read(userPostNotifierProvider(myUid).notifier).addComment(newComment);
    } else {
      ref.read(userPostNotifierProvider(postData.post.uid).notifier).addComment(
            newComment,
          );
    }

    ref.read(timelineNotifierProvider.notifier).addComment(newComment);
    ref.read(searchPostNotifierProvider.notifier).addComment(newComment);
  }

  void deleteComment(String commentId) {
    final uid = ref.watch(authStateProvider).value?.uid;
    ref.read(userPostNotifierProvider(uid).notifier).deleteComment(commentId);
    ref.read(timelineNotifierProvider.notifier).deleteComment(commentId);
    ref.read(searchPostNotifierProvider.notifier).deleteComment(commentId);
  }
}

final postManagerNotifierProvider = NotifierProvider(
  () => PostManagerNotifier(),
);
