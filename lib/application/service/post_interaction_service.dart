import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/domain/type/like.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/domain/type/profile.dart';

class PostInteractionService {
  void deletePost(
    AsyncValue<List<PostData>> state,
    String postId,
    Function(List<PostData>) onUpdate,
  ) {
    state.whenData((postData) {
      final updatedPostData =
          postData.where((postData) => postData.post.id != postId).toList();
      onUpdate(updatedPostData);
    });
  }

  void toggleLike(
    AsyncValue<List<PostData>> state,
    String postId,
    String uid,
    Function(List<PostData>) onUpdate,
  ) {
    state.whenData((postDataList) {
      final updatedPostData = postDataList.map((postData) {
        if (postData.post.id == postId) {
          final likes = List<Like>.from(postData.likes);
          final isLiked = likes.any((element) => element.uid == uid);

          if (isLiked) {
            likes.removeWhere((element) => element.uid == uid);
          } else {
            likes.add(Like(
              uid: uid,
              postId: postId,
              createdAt: DateTime.now(),
            ));
          }
          return postData.copyWith(likes: likes);
        }
        return postData;
      }).toList();

      onUpdate(updatedPostData);
    });
  }

  void addComment(
    AsyncValue<List<PostData>> state,
    Comment comment,
    Profile profile,
    Function(List<PostData>) onUpdate,
  ) {
    state.whenData((postDataList) {
      final updatedPostData = postDataList.map((postData) {
        if (postData.post.id == comment.postId) {
          final comments = List<CommentData>.from(postData.comments);
          comments.add(CommentData(
            comment: comment,
            profile: profile,
          ));
          return postData.copyWith(comments: comments);
        }
        return postData;
      }).toList();

      onUpdate(updatedPostData);
    });
  }

  void deleteComment(
    AsyncValue<List<PostData>> state,
    String commentId,
    Function(List<PostData>) onUpdate,
  ) {
    state.whenData((postDataList) {
      final updatedPostData = postDataList.map((postData) {
        final comments = postData.comments
            .where((commentData) => commentData.comment.id != commentId)
            .toList();
        return postData.copyWith(comments: comments);
      }).toList();

      onUpdate(updatedPostData);
    });
  }
}

final postInteractionServiceProvider = Provider<PostInteractionService>(
  (ref) => PostInteractionService(),
);
