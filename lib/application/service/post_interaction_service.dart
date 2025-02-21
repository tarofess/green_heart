import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/type/post.dart';

class PostInteractionService {
  void deletePost(
    AsyncValue<List<Post>> state,
    String postId,
    Function(List<Post>) onUpdate,
  ) {
    state.whenData((posts) {
      final updatedPostData = posts.where((post) => post.id != postId).toList();
      onUpdate(updatedPostData);
    });
  }

  void toggleLike(
    AsyncValue<List<Post>> state,
    String postId,
    String uid,
    bool didLike,
    Function(List<Post>) onUpdate,
  ) {
    state.whenData((posts) {
      final updatedPostData = posts.map((post) {
        if (post.id == postId) {
          if (didLike) {
            return post.copyWith(
              likeCount: post.likeCount + 1,
              isLiked: true,
            );
          } else {
            return post.copyWith(
              likeCount: post.likeCount - 1,
              isLiked: false,
            );
          }
        }
        return post;
      }).toList();

      onUpdate(updatedPostData);
    });
  }

  void addComment(
    AsyncValue<List<Post>> state,
    String postId,
    Comment comment,
    Profile profile,
    Function(List<Post>) onUpdate,
  ) {
    state.whenData((posts) {
      final updatedPostData = posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(commentCount: post.commentCount + 1);
        }
        return post;
      }).toList();

      onUpdate(updatedPostData);
    });
  }

  void deleteComment(
    AsyncValue<List<Post>> state,
    String postId,
    int deletedCommentCount,
    Function(List<Post>) onUpdate,
  ) {
    state.whenData((posts) {
      final updatedPostData = posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(
            commentCount: post.commentCount - deletedCommentCount,
          );
        }
        return post;
      }).toList();

      onUpdate(updatedPostData);
    });
  }
}
