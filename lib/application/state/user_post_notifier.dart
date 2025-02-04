import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/state/user_post_scroll_state_notifier.dart';
import 'package:green_heart/application/service/post_interaction_service.dart';
import 'package:green_heart/application/service/post_data_service.dart';

class UserPostNotifier extends FamilyAsyncNotifier<List<Post>, String?> {
  late final PostDataService _postDataService;
  late final PostInteractionService _postInteractionService;

  @override
  Future<List<Post>> build(String? arg) async {
    if (arg == null) {
      throw Exception('ユーザーの投稿を取得できません。再度お試しください。');
    }

    _postDataService = ref.read(postDataServiceProvider);
    _postInteractionService = ref.read(postInteractionServiceProvider);

    final posts = await _fetchNextPosts(arg);
    final updatedPosts = await _postDataService.updateIsLikedStatus(posts);
    final filteredPosts = await _postDataService.filterByBlock(updatedPosts);

    return filteredPosts;
  }

  Future<List<Post>> _fetchNextPosts(String uid) async {
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
        final newPosts = await _fetchNextPosts(uid);
        final newPostData = await _postDataService.filterByBlock(newPosts);

        final updatedPosts = [
          ...currentPosts,
          ...newPostData.where((newPost) =>
              !currentPosts.any((currentPost) => currentPost.id == newPost.id))
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
      final posts = await _fetchNextPosts(uid);
      return await _postDataService.filterByBlock(posts);
    });
  }

  void addPost(Post newPost) {
    state = state.whenData((posts) => [newPost, ...posts]);
  }

  void deletePost(String postId) {
    _postInteractionService.deletePost(state, postId, (updatedPosts) {
      state = AsyncValue.data(updatedPosts);
    });
  }

  void toggleLike(String postId, String uid, bool didLike) {
    _postInteractionService.toggleLike(state, postId, uid, didLike,
        (updatedPosts) {
      state = AsyncValue.data(updatedPosts);
    });
  }

  void addComment(String postId, Comment comment) {
    final profile = ref.read(profileNotifierProvider).value;
    if (profile == null) {
      throw Exception('プロフィール情報が取得できませんでした。再度お試しください。');
    }
    _postInteractionService.addComment(state, postId, comment, profile,
        (updatedPosts) {
      state = AsyncValue.data(updatedPosts);
    });
  }

  void deleteComment(String postId, int deletedCommentCount) {
    _postInteractionService.deleteComment(state, postId, deletedCommentCount,
        (updatedPosts) {
      state = AsyncValue.data(updatedPosts);
    });
  }

  void updateProfile(String uid, String name, String? imageUrl) {
    updateProfileName(uid, name);
    updateProfileImage(uid, imageUrl);
  }

  void updateProfileName(String uid, String name) {
    state.whenData((posts) {
      final updatedPostData = posts.map((post) {
        if (post.uid == uid) {
          return post.copyWith(userName: name);
        }
        return post;
      }).toList();

      state = AsyncValue.data(updatedPostData);
    });
  }

  void updateProfileImage(String uid, String? imageUrl) {
    state.whenData((posts) {
      final updatedPostData = posts.map((post) {
        if (post.uid == uid) {
          return post.copyWith(userImage: imageUrl);
        }
        return post;
      }).toList();

      state = AsyncValue.data(updatedPostData);
    });
  }
}

final userPostNotifierProvider =
    AsyncNotifierProviderFamily<UserPostNotifier, List<Post>, String?>(
  UserPostNotifier.new,
);
