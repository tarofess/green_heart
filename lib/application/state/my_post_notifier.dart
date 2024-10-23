import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/di/profile_di.dart';

class MyPostNotifier extends AsyncNotifier<(List<Post>, Profile?)> {
  @override
  Future<(List<Post>, Profile?)> build() async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザーが存在しないので投稿を取得できません。再度お試しください。');
    }

    final posts = await ref.read(postGetUsecaseProvider).execute(uid);
    final profile = await ref.read(profileGetUsecaseProvider).execute(uid);
    return (posts, profile);
  }

  void addPost(Post post) {
    state = state.whenData((currentState) {
      final updatedPosts = [post, ...currentState.$1];
      return (updatedPosts, currentState.$2);
    });
  }

  void removeAllPosts() {
    state = const AsyncValue.data(([], null));
  }

  void updateLikedUserIds(String postId, String userId) {
    state.whenData((currentState) {
      final updatedPosts = currentState.$1.map((post) {
        if (post.id == postId) {
          final updatedLikedUserIds = List<String>.from(post.likedUserIds);
          if (updatedLikedUserIds.contains(userId)) {
            updatedLikedUserIds.remove(userId);
          } else {
            updatedLikedUserIds.add(userId);
          }
          return post.copyWith(likedUserIds: updatedLikedUserIds);
        }
        return post;
      }).toList();

      state = AsyncValue.data((updatedPosts, currentState.$2));
    });
  }
}

final myPostNotifierProvider =
    AsyncNotifierProvider<MyPostNotifier, (List<Post>, Profile?)>(
  () => MyPostNotifier(),
);
