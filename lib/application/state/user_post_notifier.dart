import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/comment_data.dart';
import 'package:green_heart/domain/type/like.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/application/state/user_post_scroll_state_notifier.dart';
import 'package:green_heart/application/di/comment_di.dart';
import 'package:green_heart/application/di/like_di.dart';
import 'package:green_heart/application/di/block_di.dart';

class UserPostNotifier extends FamilyAsyncNotifier<List<PostData>, String?> {
  @override
  Future<List<PostData>> build(String? arg) async {
    if (arg == null) {
      throw Exception('ユーザーの投稿を取得できません。再度お試しください。');
    }

    final posts = await _fetchNextBatch(arg);
    final postData = await _createPostDataList(posts);
    final filteredPostsByBlock = await _filterCommentsByBlock(postData);
    return filteredPostsByBlock;
  }

  Future<List<Post>> _fetchNextBatch(String uid) async {
    final userPostScrollState =
        ref.read(userPostScrollStateNotifierProvider(uid));
    if (!userPostScrollState.hasMore) return [];

    final posts = await ref.read(postGetUsecaseProvider).execute(
          uid,
          userPostScrollState,
          ref.read(userPostScrollStateNotifierProvider(uid).notifier),
        );

    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return posts;
  }

  Future<void> loadMore(String? uid) async {
    if (uid == null) {
      throw Exception('ユーザーの投稿を取得できません。再度お試しください。');
    }

    final userPostScrollState =
        ref.read(userPostScrollStateNotifierProvider(uid));
    if (!userPostScrollState.hasMore) return;

    state.whenData((currentPosts) async {
      try {
        final newPosts = await _fetchNextBatch(uid);
        final newPostData = await _createPostDataList(newPosts);
        final filteredPostsByBlock = await _filterCommentsByBlock(newPostData);

        final updatedPosts = [
          ...currentPosts,
          ...filteredPostsByBlock.where((newPost) => !currentPosts
              .any((currentPost) => currentPost.post.id == newPost.post.id))
        ];
        state = AsyncValue.data(updatedPosts);
      } catch (e) {
        state = AsyncError(e, StackTrace.current);
      }
    });
  }

  Future<void> refresh(String? uid) async {
    if (uid == null) {
      throw Exception('ユーザーの投稿を取得できません。再度お試しください。');
    }

    ref.read(userPostScrollStateNotifierProvider(uid).notifier)
      ..updateLastDocument(null)
      ..updateHasMore(true);
    state = await AsyncValue.guard(() async {
      final posts = await _fetchNextBatch(uid);
      final postData = await _createPostDataList(posts);
      final filteredPostsByBlock = await _filterCommentsByBlock(postData);
      return filteredPostsByBlock;
    });
  }

  Future<List<PostData>> _filterCommentsByBlock(
    List<PostData> postDataList,
  ) async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザー情報が取得できません。再度お試し下さい。');
    }

    final blockList = await ref.read(blockGetUsecaseProvider).execute(uid);
    final blockedUids = blockList.map((block) => block.blockedUid).toSet();
    final filteredPosts = postDataList.map((postData) {
      final comments = List<CommentData>.from(postData.comments);
      comments.removeWhere(
        (commentData) => blockedUids.contains(commentData.comment.uid),
      );
      return postData.copyWith(comments: comments);
    }).toList();
    return filteredPosts;
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

  Future<void> addPost(
    String content,
    List<String> selectedImages,
    DateTime selectedDay,
  ) async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('投稿ができません。アカウントがログアウトされている可能性があります。');
    }

    final addedPost = await ref.read(postAddUsecaseProvider).execute(
          uid,
          content,
          selectedImages,
          selectedDay,
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

  Future<void> deletePost(String postId) async {
    state.whenData((postDataList) {
      final updatedPostData =
          postDataList.where((postData) => postData.post.id != postId).toList();
      state = AsyncValue.data(updatedPostData);
    });
  }

  Future<void> deleteAllPosts(User user) async {
    await ref.read(postDeleteAllUsecaseProvider).execute(user);
    state = const AsyncValue.data([]);
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

  void updateProfile(String uid, String name, String? imageUrl) {
    updateProfileName(uid, name);
    updateProfileImage(uid, imageUrl);
  }

  void updateProfileName(String uid, String name) {
    state.whenData((postDataList) {
      final updatedPostData = postDataList.map((postData) {
        if (postData.userProfile?.uid == uid) {
          final updatedProfile = postData.userProfile?.copyWith(name: name);
          return postData.copyWith(userProfile: updatedProfile);
        }
        return postData;
      }).toList();

      state = AsyncValue.data(updatedPostData);
    });
  }

  void updateProfileImage(String uid, String? imageUrl) {
    state.whenData((postDataList) {
      final updatedPostData = postDataList.map((postData) {
        if (postData.userProfile?.uid == uid) {
          final updatedProfile =
              postData.userProfile?.copyWith(imageUrl: imageUrl);
          return postData.copyWith(userProfile: updatedProfile);
        }
        return postData;
      }).toList();

      state = AsyncValue.data(updatedPostData);
    });
  }
}

final userPostNotifierProvider =
    AsyncNotifierProviderFamily<UserPostNotifier, List<PostData>, String?>(
        UserPostNotifier.new);
