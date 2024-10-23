import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/post_data.dart';

class TimelineNotifier extends AsyncNotifier<List<PostData>> {
  @override
  Future<List<PostData>> build() async {
    final posts = await ref.read(timelineGetUsecaseProvider).execute();
    List<PostData> postData = [];

    for (var post in posts) {
      final profile =
          await ref.read(profileGetUsecaseProvider).execute(post.uid);
      final commentCount =
          await ref.read(commentGetUsecaseProvider).execute(post.id);

      postData.add(
        PostData(
          post: post,
          userProfile: profile,
          commentCount: commentCount.length,
        ),
      );
    }

    return postData;
  }

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

final timelineNotifierProvider =
    AsyncNotifierProvider<TimelineNotifier, List<PostData>>(
  () => TimelineNotifier(),
);
