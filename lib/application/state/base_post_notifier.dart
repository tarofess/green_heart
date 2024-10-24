import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/post_data.dart';

abstract class BasePostNotifier extends AsyncNotifier<List<PostData>> {
  void updateLikedUserIds(String postId, String userId) {
    state.whenData((currentState) {
      final updatedPosts = currentState.map((postData) {
        if (postData.post.id == postId) {
          final updatedLikedUserIds =
              List<String>.from(postData.post.likedUserIds);
          if (updatedLikedUserIds.contains(userId)) {
            updatedLikedUserIds.remove(userId);
          } else {
            updatedLikedUserIds.add(userId);
          }
          return postData.copyWith(
            post: postData.post.copyWith(likedUserIds: updatedLikedUserIds),
          );
        }
        return postData;
      }).toList();

      state = AsyncValue.data(updatedPosts);
    });
  }

  void updateCommentCount(String postId) {
    state.whenData((currentState) {
      final updatedPosts = currentState.map((postData) {
        if (postData.post.id == postId) {
          return postData.copyWith(commentCount: postData.commentCount + 1);
        }
        return postData;
      }).toList();

      state = AsyncValue.data(updatedPosts);
    });
  }
}
