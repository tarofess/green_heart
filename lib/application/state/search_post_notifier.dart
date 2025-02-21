import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/application/service/post_interaction_service.dart';
import 'package:green_heart/application/service/post_data_service.dart';
import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/domain/type/block.dart';
import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';

class SearchPostNotifier extends AsyncNotifier<List<Post>> {
  late PostDataService _postDataService;
  late PostInteractionService _postInteractionService;
  late AsyncValue<List<Block>> _blockState;

  @override
  Future<List<Post>> build() async {
    _postDataService = ref.read(postDataServiceProvider);
    _postInteractionService = ref.read(postInteractionServiceProvider);
    _blockState = ref.watch(blockNotifierProvider);

    return [];
  }

  Future<void> setPostsBySearchWord(List<Post> posts) async {
    final uid = ref.watch(authStateProvider).value?.uid;

    final filteredPosts =
        await _postDataService.filterByBlock(posts, _blockState, uid);
    final updatedPosts =
        await _postDataService.updateIsLikedStatus(filteredPosts, uid);
    state = AsyncValue.data([...state.value ?? [], ...updatedPosts]);
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

  void reset() {
    state = const AsyncValue.data([]);
  }
}

final searchPostNotifierProvider =
    AsyncNotifierProvider<SearchPostNotifier, List<Post>>(
  () => SearchPostNotifier(),
);
