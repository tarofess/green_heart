import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/domain/type/like.dart';
import 'package:green_heart/domain/type/comment.dart';

class UserPostNotifier extends FamilyAsyncNotifier<List<PostData>, String?> {
  @override
  Future<List<PostData>> build(String? arg) async {
    if (arg == null) {
      throw Exception('ユーザーが存在しないので投稿を取得できません。再度お試しください。');
    }

    final postData = await _createPostDataList(arg);
    return postData;
  }

  Future<List<PostData>> _createPostDataList(String userUid) async {
    List<PostData> postData = [];

    final posts = await ref.read(postGetUsecaseProvider).execute(userUid);
    for (var post in posts) {
      final profile =
          await ref.read(profileGetUsecaseProvider).execute(userUid);
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

  Future<void> addPost(String content, List<String> selectedImages) async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('投稿ができません。アカウントがログアウトされている可能性があります。');
    }

    final addedPost = await ref.read(postAddUsecaseProvider).execute(
          uid,
          content,
          selectedImages,
        );

    final profile = await ref.read(profileGetUsecaseProvider).execute(uid);

    final newPostData = PostData(
      post: addedPost,
      userProfile: profile,
      likes: [],
      comments: [],
    );

    state = state.whenData((posts) => [newPostData, ...posts]);
  }

  void toggleLike(String postId, String uid) {
    state.whenData((value) {
      final updatedValue = value.map((post) {
        if (post.post.id == postId) {
          final likes = List<Like>.from(post.likes);
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
          return post.copyWith(likes: likes);
        }
        return post;
      }).toList();

      state = AsyncValue.data(updatedValue);
    });
  }

  void addComment(Comment comment) {
    state.whenData((value) {
      final updatedValue = value.map((post) {
        if (post.post.id == comment.postId) {
          final comments = List<CommentData>.from(post.comments);
          final profile = ref.read(profileNotifierProvider).value;
          comments.add(CommentData(
            comment: comment,
            profile: profile,
          ));
          return post.copyWith(comments: comments);
        }
        return post;
      }).toList();

      state = AsyncValue.data(updatedValue);
    });
  }

  void deleteComment(String commentId) {
    state.whenData((value) {
      final updatedValue = value.map((post) {
        final comments = List<CommentData>.from(post.comments);
        comments.removeWhere((element) =>
            element.comment.id == commentId ||
            element.comment.parentCommentId == commentId);
        return post.copyWith(comments: comments);
      }).toList();

      state = AsyncValue.data(updatedValue);
    });
  }

  Future<void> removeAllPosts() async {
    state = const AsyncValue.data([]);
  }
}

final userPostNotifierProvider =
    AsyncNotifierProviderFamily<UserPostNotifier, List<PostData>, String?>(
        UserPostNotifier.new);
