import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/domain/type/post_with_profile.dart';

class TimelineNotifier extends AsyncNotifier<List<PostWithProfile>> {
  @override
  Future<List<PostWithProfile>> build() async {
    final posts = await ref.read(timelineGetUsecaseProvider).execute();
    return posts;
  }

  void addPost(PostWithProfile post) {
    state = AsyncValue.data([post, ...state.value ?? []]);
  }

  void updateLikedUserIds(String postId, String userId) {
    state = AsyncValue.data(
      state.value?.map((postWithProfile) {
            if (postWithProfile.post.id == postId) {
              final updatedLikedUserIds = List<String>.from(
                postWithProfile.post.likedUserIds,
              );

              if (updatedLikedUserIds.contains(userId)) {
                updatedLikedUserIds.remove(userId);
              } else {
                updatedLikedUserIds.add(userId);
              }
              return postWithProfile.copyWith(
                post: postWithProfile.post.copyWith(
                  likedUserIds: updatedLikedUserIds,
                ),
              );
            }
            return postWithProfile;
          }).toList() ??
          [],
    );
  }
}

final timelineNotifierProvider =
    AsyncNotifierProvider<TimelineNotifier, List<PostWithProfile>>(
  () => TimelineNotifier(),
);
