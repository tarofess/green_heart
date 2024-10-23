import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/domain/type/comment_data.dart';

class MyPostNotifier extends AsyncNotifier<List<PostData>> {
  @override
  Future<List<PostData>> build() async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザーが存在しないので投稿を取得できません。再度お試しください。');
    }

    final posts = await ref.read(postGetUsecaseProvider).execute(uid);
    List<PostData> postData = [];

    for (var post in posts) {
      final profile =
          await ref.read(profileGetUsecaseProvider).execute(post.uid);
      final comments =
          await ref.read(commentGetUsecaseProvider).execute(post.id);

      final commentDataList = await Future.wait(comments.map((comment) async {
        final commentUserProfile =
            await ref.read(profileGetUsecaseProvider).execute(comment.uid);
        return CommentData(
          comment: comment,
          userProfile: commentUserProfile,
        );
      }));

      final likeCount = post.likedUserIds.length;

      postData.add(PostData(
          post: post,
          userProfile: profile,
          comments: commentDataList,
          likeCount: likeCount));
    }

    return postData;
  }

  void addPost(Post post) {
    state.whenData((currentState) {
      final updatedPosts = List<PostData>.from(currentState);
      updatedPosts.insert(
          0,
          PostData(
            post: post,
            userProfile: null,
            comments: [],
            likeCount: 0,
          ));

      state = AsyncValue.data(updatedPosts);
    });
  }

  void removeAllPosts() {
    state = const AsyncValue.data([]);
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
}

final myPostNotifierProvider =
    AsyncNotifierProvider<MyPostNotifier, List<PostData>>(
  () => MyPostNotifier(),
);
