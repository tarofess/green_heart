import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/application/state/search_post_notifier.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/state/notification_detail_post_notifier.dart';

class PostManagerNotifier extends Notifier {
  @override
  void build() {}

  void deletePost(String uid, Post post) {
    ref.read(userPostNotifierProvider(uid).notifier).deletePost(
          post.id,
        );
    ref.read(timelineNotifierProvider.notifier).deletePost(
          post.id,
        );
    ref.read(searchPostNotifierProvider.notifier).deletePost(
          post.id,
        );
    ref
        .read(notificationDetailPostNotifierProvider(post.id).notifier)
        .deletePost(post.id);
  }

  void toggleLike(Post post, String uid, bool didLike) {
    ref.read(userPostNotifierProvider(post.uid).notifier).toggleLike(
          post.id,
          uid,
          didLike,
        );
    ref.read(timelineNotifierProvider.notifier).toggleLike(
          post.id,
          uid,
          didLike,
        );
    ref.read(searchPostNotifierProvider.notifier).toggleLike(
          post.id,
          uid,
          didLike,
        );
    ref
        .read(notificationDetailPostNotifierProvider(post.id).notifier)
        .toggleLike(
          post.id,
          uid,
          didLike,
        );
  }

  void addComment(Comment newComment, Post post) {
    final myUid = ref.watch(authStateProvider).value?.uid;
    if (post.uid == myUid) {
      ref.read(userPostNotifierProvider(myUid).notifier).addComment(
            post.id,
            newComment,
          );
    } else {
      ref.read(userPostNotifierProvider(post.uid).notifier).addComment(
            post.id,
            newComment,
          );
    }

    ref.read(timelineNotifierProvider.notifier).addComment(
          post.id,
          newComment,
        );
    ref.read(searchPostNotifierProvider.notifier).addComment(
          post.id,
          newComment,
        );
    ref
        .read(notificationDetailPostNotifierProvider(post.id).notifier)
        .addComment(
          post.id,
          newComment,
        );
  }

  void deleteComment(String postId, int deletedCommentCount) {
    final uid = ref.watch(authStateProvider).value?.uid;
    ref.read(userPostNotifierProvider(uid).notifier).deleteComment(
          postId,
          deletedCommentCount,
        );
    ref.read(timelineNotifierProvider.notifier).deleteComment(
          postId,
          deletedCommentCount,
        );
    ref.read(searchPostNotifierProvider.notifier).deleteComment(
          postId,
          deletedCommentCount,
        );
    ref
        .read(notificationDetailPostNotifierProvider(postId).notifier)
        .deleteComment(
          postId,
          deletedCommentCount,
        );
  }
}

final postManagerNotifierProvider = NotifierProvider(
  () => PostManagerNotifier(),
);
