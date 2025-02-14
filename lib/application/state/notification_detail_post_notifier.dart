import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/service/post_interaction_service.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/comment.dart';
import 'package:green_heart/application/service/post_data_service.dart';

class NotificationDetailPostNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Post>, String> {
  late final PostDataService _postDataService;
  late final PostInteractionService _postInteractionService;

  @override
  Future<List<Post>> build(String arg) async {
    _postDataService = ref.read(postDataServiceProvider);
    _postInteractionService = ref.read(postInteractionServiceProvider);

    final posts = await ref.read(postGetByIdUsecaseProvider).execute(arg);
    final updatedPosts = await _postDataService.updateIsLikedStatus(posts);
    return updatedPosts;
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

final notificationDetailPostNotifierProvider =
    AutoDisposeAsyncNotifierProviderFamily<NotificationDetailPostNotifier,
        List<Post>, String>(
  () => NotificationDetailPostNotifier(),
);
