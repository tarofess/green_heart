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
    final postData = await Future.wait(posts.map(_createPostData));
    final filteredPostData = await _filterByBlock(postData);
    state = [...state, ...filteredPostData];
  }

  Future<PostData> _createPostData(Post post) async {
    final results = await Future.wait([
      ref.read(profileGetUsecaseProvider).execute(post.uid),
      ref.read(likeGetUsecaseProvider).execute(post.id),
      ref.read(commentGetUsecaseProvider).execute(post.id),
    ]);

    final profile = results[0] as Profile;
    final likes = results[1] as List<Like>;
    final comments = results[2] as List<Comment>;

    final commentData = await Future.wait(comments.map(_createCommentData));

    return PostData(
      post: post,
      userProfile: profile,
      likes: likes,
      comments: commentData,
    );
  }

  Future<CommentData> _createCommentData(Comment comment) async {
    final profile =
        await ref.read(profileGetUsecaseProvider).execute(comment.uid);
    return CommentData(comment: comment, profile: profile);
  }

  Future<List<PostData>> _filterByBlock(List<PostData> postData) async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザーが存在しないため投稿を取得できません。再度お試しください。');
    }

    final blockList = await ref.read(blockGetUsecaseProvider).execute(uid);
    final blockedUids = blockList.map((block) => block.blockedUid).toSet();

    return postData.where((postData) {
      final isPostBlocked = blockedUids.contains(postData.post.uid);
      if (isPostBlocked) {
        return false; // 投稿自体がブロックされている場合は除外
      }

      // 投稿がブロックされていない場合のみコメントをフィルタリング
      final filteredComments = postData.comments
          .where(
              (commentData) => !blockedUids.contains(commentData.comment.uid))
          .toList();

      postData = postData.copyWith(comments: filteredComments);

      return true;
    }).toList();
  }

  void deletePost(String postId) {
    state = state.where((postData) => postData.post.id != postId).toList();
  }

  void toggleLike(String postId, String uid) {
    state = state.map((postData) {
      if (postData.post.id == postId) {
        final likes = List<Like>.from(postData.likes);
        if (likes.any((like) => like.uid == uid)) {
          likes.removeWhere((like) => like.uid == uid);
        } else {
          likes.add(Like(uid: uid, postId: postId, createdAt: DateTime.now()));
        }
        return postData.copyWith(likes: likes);
      }
      return postData;
    }).toList();
  }

  void addComment(Comment comment) {
    state = state.map((postData) {
      if (postData.post.id == comment.postId) {
        final comments = List<CommentData>.from(postData.comments);
        final profile = ref.read(profileNotifierProvider).value;
        comments.add(CommentData(comment: comment, profile: profile));
        return postData.copyWith(comments: comments);
      }
      return postData;
    }).toList();
  }

  void deleteComment(String commentId) {
    state = state.map((postData) {
      final comments = postData.comments
          .where((commentData) => commentData.comment.id != commentId)
          .toList();
      return postData.copyWith(comments: comments);
    }).toList();
  }

  void reset() {
    state = [];
  }
}

final searchPostNotifierProvider =
    NotifierProvider<SearchPostNotifier, List<PostData>>(
  () => SearchPostNotifier(),
);
