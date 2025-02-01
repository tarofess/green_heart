import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/state/user_post_scroll_state_notifier.dart';
import 'package:green_heart/application/service/post_interaction_service.dart';
import 'package:green_heart/application/service/post_data_service.dart';

class UserPostNotifier extends FamilyAsyncNotifier<List<PostData>, String?> {
  late final PostDataService _postDataService;
  late final PostInteractionService _postInteractionService;

  @override
  Future<List<PostData>> build(String? arg) async {
    if (arg == null) {
      throw Exception('ユーザーの投稿を取得できません。再度お試しください。');
    }

    _postDataService = ref.read(postDataServiceProvider);
    _postInteractionService = ref.read(postInteractionServiceProvider);

    final posts = await _fetchNextPosts(arg);
    final postDataList =
        await _postDataService.createAndFilterPostDataList(posts);
    return postDataList;
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
        final newPostData =
            await _postDataService.createAndFilterPostDataList(newPosts);

        final updatedPosts = [
          ...currentPosts,
          ...newPostData.where((newPost) => !currentPosts
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
      final posts = await _fetchNextPosts(uid);
      return await _postDataService.createAndFilterPostDataList(posts);
    });
  }

  void addPost(PostData newPostData) {
    state = state.whenData((posts) => [newPostData, ...posts]);
  }

  void deletePost(String postId) {
    _postInteractionService.deletePost(state, postId, (updatedPosts) {
      state = AsyncValue.data(updatedPosts);
    });
  }

  void toggleLike(String postId, String uid) {
    _postInteractionService.toggleLike(state, postId, uid, (updatedPosts) {
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

  void deleteComment(String commentId) {
    _postInteractionService.deleteComment(state, commentId, (updatedPosts) {
      state = AsyncValue.data(updatedPosts);
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
  UserPostNotifier.new,
);
