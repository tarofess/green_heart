import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/type/comment.dart';

class TimelineNotifier
    extends AsyncNotifier<(List<Post>, List<Profile?>, List<List<Comment>>)> {
  @override
  Future<(List<Post>, List<Profile?>, List<List<Comment>>)> build() async {
    final posts = await ref.read(timelineGetUsecaseProvider).execute();
    List<Profile?> profiles = [];
    for (var post in posts) {
      final profile =
          await ref.read(profileGetUsecaseProvider).execute(post.uid);
      profiles.add(profile);
    }
    List<List<Comment>> comments = [];
    for (var post in posts) {
      final comment =
          await ref.read(commentGetUsecaseProvider).execute(post.id);
      comments.add(comment);
    }

    return (posts, profiles, comments);
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

      state = AsyncValue.data((updatedPosts, currentState.$2, currentState.$3));
    });
  }
}

final timelineNotifierProvider = AsyncNotifierProvider<TimelineNotifier,
    (List<Post>, List<Profile?>, List<List<Comment>>)>(
  () => TimelineNotifier(),
);
