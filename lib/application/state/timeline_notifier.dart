import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/service/post_interaction_service.dart';
import 'package:green_heart/application/service/post_data_service.dart';
import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/domain/type/block.dart';

class TimelineNotifier extends AsyncNotifier<List<Post>> {
  late PostDataService _postDataService;
  late PostInteractionService _postInteractionService;
  late AsyncValue<List<Block>> _blockState;
  List<Post> _allPosts = [];

  @override
  Future<List<Post>> build() async {
    _postDataService = ref.read(postDataServiceProvider);
    _postInteractionService = ref.read(postInteractionServiceProvider);
    _blockState = ref.read(blockNotifierProvider);

    final posts = await ref.read(timelineGetUsecaseProvider).execute();
    final updatedPosts = await _postDataService.updateIsLikedStatus(posts);
    final filteredPosts =
        await _postDataService.filterByBlock(updatedPosts, _blockState);

    // ブロックの状態変更で投稿が変わるのに備えて全通知を保持しておく
    _allPosts = filteredPosts;

    // ブロック情報が更新された場合、保持している投稿データに再度フィルターを適用する
    ref.listen<AsyncValue<List<Block>>>(blockNotifierProvider,
        (previous, next) async {
      _blockState = next;
      state = AsyncValue.data(
        await _postDataService.filterByBlock(_allPosts, next),
      );
    });

    return filteredPosts;
  }

  Future<void> loadMore(List<Post> posts) async {
    state.whenData((currentPosts) async {
      try {
        final updatedLikePosts =
            await _postDataService.updateIsLikedStatus(posts);
        final filteredPosts =
            await _postDataService.filterByBlock(updatedLikePosts, _blockState);

        final updatedPosts = [
          ...currentPosts,
          ...filteredPosts.where((newPost) =>
              !currentPosts.any((currentPost) => currentPost.id == newPost.id))
        ];
        state = AsyncValue.data(updatedPosts);
      } catch (e) {
        state = AsyncError(e, StackTrace.current);
      }
    });
  }

  Future<void> refresh(List<Post> posts) async {
    state = await AsyncValue.guard(() async {
      final updatedLikePosts =
          await _postDataService.updateIsLikedStatus(posts);

      return await _postDataService.filterByBlock(
          updatedLikePosts, _blockState);
    });
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
}

final timelineNotifierProvider =
    AsyncNotifierProvider<TimelineNotifier, List<Post>>(
  () => TimelineNotifier(),
);
