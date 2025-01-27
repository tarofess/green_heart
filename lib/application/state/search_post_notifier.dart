import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/application/service/post_interaction_service.dart';
import 'package:green_heart/application/service/post_data_service.dart';

class SearchPostNotifier extends AsyncNotifier<List<PostData>> {
  late final PostDataService _postDataService;
  late final PostInteractionService _postInteractionService;

  @override
  List<PostData> build() {
    _postDataService = ref.read(postDataServiceProvider);
    _postInteractionService = ref.read(postInteractionServiceProvider);
    return [];
  }

  Future<void> setPostsBySearchWord(List<Post> posts) async {
    final postData = await _postDataService.createAndFilterPostDataList(posts);
    state = AsyncValue.data([...state.value ?? [], ...postData]);
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

  void reset() {
    state = const AsyncValue.data([]);
  }
}

final searchPostNotifierProvider =
    AsyncNotifierProvider<SearchPostNotifier, List<PostData>>(
  () => SearchPostNotifier(),
);
