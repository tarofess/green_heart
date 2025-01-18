import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/application/di/comment_di.dart';
import 'package:green_heart/application/di/like_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/domain/type/like.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/application/di/block_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/profile_notifier.dart';

class SearchPostNotifier extends Notifier<List<PostData>> {
  @override
  List<PostData> build() {
    return [];
  }

  Future<void> setPostsBySearchWord(List<Post> posts) async {
    final postData = await _createPostDataList(posts);
    final postDataFilteredByBlock = await _filterByBlock(postData);
    state = [...state, ...postDataFilteredByBlock];
  }

  Future<List<PostData>> _createPostDataList(List<Post> posts) async {
    List<PostData> postData = [];

    final postDataFutures = posts.map((post) async {
      final results = await Future.wait([
        ref.read(profileGetUsecaseProvider).execute(post.uid),
        ref.read(likeGetUsecaseProvider).execute(post.id),
        ref.read(commentGetUsecaseProvider).execute(post.id),
      ]);
      final profile = results[0] as Profile;
      final likes = results[1] as List<Like>;
      final comments = results[2] as List<Comment>;

      final commentDataFutures = comments.map((comment) async {
        final profile =
            await ref.read(profileGetUsecaseProvider).execute(comment.uid);
        return CommentData(comment: comment, profile: profile);
      });

      final commentData = await Future.wait(commentDataFutures);
      return PostData(
        post: post,
        userProfile: profile,
        likes: likes,
        comments: commentData,
      );
    });

    postData = await Future.wait(postDataFutures);
    return postData;
  }

  Future<List<PostData>> _filterByBlock(List<PostData> postDataList) async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザーが存在しないので投稿を取得できません。再度お試しください。');
    }

    final blockList = await ref.read(blockGetUsecaseProvider).execute(uid);
    final blockedUids = blockList.map((block) => block.blockedUid).toSet();

    final filteredPosts = postDataList
        .where((postData) => !blockedUids.contains(postData.post.uid))
        .toList();
    final filteredCommentPosts = filteredPosts.map((postData) {
      final comments = List<CommentData>.from(postData.comments);
      comments.removeWhere(
        (commentData) => blockedUids.contains(commentData.comment.uid),
      );
      return postData.copyWith(comments: comments);
    }).toList();

    return filteredCommentPosts;
  }

  void deletePost(String postId) {
    final updatedPostData =
        state.where((postData) => postData.post.id != postId).toList();
    state = updatedPostData;
  }

  void toggleLike(String postId, String uid) {
    final updatedPostData = state.map((postData) {
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

    state = updatedPostData;
  }

  void addComment(Comment comment) {
    final updatedPostData = state.map((postData) {
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

    state = updatedPostData;
  }

  void deleteComment(String commentId) {
    final updatedPostData = state.map((postData) {
      final comments = List<CommentData>.from(postData.comments);
      comments.removeWhere((commentData) =>
          commentData.comment.id == commentId ||
          commentData.comment.parentCommentId == commentId);
      return postData.copyWith(comments: comments);
    }).toList();

    state = updatedPostData;
  }

  void reset() {
    state = [];
  }
}

final searchPostNotifierProvider =
    NotifierProvider<SearchPostNotifier, List<PostData>>(
  () => SearchPostNotifier(),
);
