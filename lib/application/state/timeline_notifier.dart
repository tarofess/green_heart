import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/domain/type/like.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/post.dart';

class TimelineNotifier extends AsyncNotifier<List<PostData>> {
  @override
  Future<List<PostData>> build() async {
    final posts = await ref.read(timelineGetUsecaseProvider).execute();
    final postData = await _createPostDataList(posts);
    return postData;
  }

  Future<List<PostData>> _createPostDataList(List<Post> posts) async {
    List<PostData> postData = [];

    for (var post in posts) {
      final profile =
          await ref.read(profileGetUsecaseProvider).execute(post.uid);
      final likes = await ref.read(likeGetUsecaseProvider).execute(post.id);
      final comments =
          await ref.read(commentGetUsecaseProvider).execute(post.id);

      List<CommentData> commentData = [];
      for (var comment in comments) {
        final profile = await ref.read(profileGetUsecaseProvider).execute(
              comment.uid,
            );
        commentData.add(CommentData(
          comment: comment,
          profile: profile,
        ));
      }

      postData.add(PostData(
        post: post,
        userProfile: profile,
        likes: likes,
        comments: commentData,
      ));
    }

    return postData;
  }

  Future<void> deletePost(String postId) async {
    state.whenData((postData) {
      final updatedPostData =
          postData.where((postData) => postData.post.id != postId).toList();
      state = AsyncValue.data(updatedPostData);
    });
  }

  void toggleLike(String postId, String uid) {
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

      state = AsyncValue.data(updatedPostData);
    });
  }

  void addComment(Comment comment) {
    state.whenData((postDataList) {
      final updatedPostData = postDataList.map((postData) {
        if (postData.post.id == comment.postId) {
          final comments = List<CommentData>.from(postData.comments);
          final profile = ref.read(profileNotifierProvider).value;
          comments.add(CommentData(
            comment: comment,
            profile: profile,
          ));
          return postData.copyWith(comments: comments);
        }
        return postData;
      }).toList();

      state = AsyncValue.data(updatedPostData);
    });
  }

  void deleteComment(String commentId) {
    state.whenData((postDataList) {
      final updatedPostData = postDataList.map((postData) {
        final comments = List<CommentData>.from(postData.comments);
        comments.removeWhere((commentData) =>
            commentData.comment.id == commentId ||
            commentData.comment.parentCommentId == commentId);
        return postData.copyWith(comments: comments);
      }).toList();

      state = AsyncValue.data(updatedPostData);
    });
  }
}

final timelineNotifierProvider =
    AsyncNotifierProvider<TimelineNotifier, List<PostData>>(
  () => TimelineNotifier(),
);
