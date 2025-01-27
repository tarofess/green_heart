import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/state/timeline_scroll_state_notifier.dart';
import 'package:green_heart/application/service/post_interaction_service.dart';
import 'package:green_heart/application/service/post_data_service.dart';

class TimelineNotifier extends AsyncNotifier<List<PostData>> {
  late final PostDataService _postDataService;
  late final PostInteractionService _postInteractionService;

  @override
  Future<List<PostData>> build() async {
    _postDataService = ref.read(postDataServiceProvider);
    _postInteractionService = ref.read(postInteractionServiceProvider);

    final posts = await _fetchNextPosts();
    final postDataList =
        await _postDataService.createAndFilterPostDataList(posts);
    return postDataList;
  }

  Future<List<Post>> _fetchNextPosts() async {
    final timeLineScrollState = ref.read(timelineScrollStateNotifierProvider);
    if (!timeLineScrollState.hasMore) return [];

    final posts = await ref.read(timelineGetUsecaseProvider).execute(
          timeLineScrollState,
          ref.read(timelineScrollStateNotifierProvider.notifier),
        );
    return posts;
  }

  Future<void> loadMore() async {
    final timeLineScrollState = ref.read(timelineScrollStateNotifierProvider);
    if (!timeLineScrollState.hasMore) return;

    state.whenData((currentPosts) async {
      try {
        final newPosts = await _fetchNextPosts();
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

  Future<void> refresh() async {
    ref.read(timelineScrollStateNotifierProvider.notifier)
      ..updateLastDocument(null)
      ..updateHasMore(true);

    state = await AsyncValue.guard(() async {
      final posts = await _fetchNextPosts();
      return await _postDataService.createAndFilterPostDataList(posts);
    });
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

  void addComment(Comment comment) {
    final profile = ref.read(profileNotifierProvider).value;
    if (profile == null) {
      throw Exception('プロフィール情報が取得できませんでした。再度お試しください。');
    }
    _postInteractionService.addComment(state, comment, profile, (updatedPosts) {
      state = AsyncValue.data(updatedPosts);
    });
  }

  void deleteComment(String commentId) {
    _postInteractionService.deleteComment(state, commentId, (updatedPosts) {
      state = AsyncValue.data(updatedPosts);
    });
  }
}

final timelineNotifierProvider =
    AsyncNotifierProvider<TimelineNotifier, List<PostData>>(
  () => TimelineNotifier(),
);
