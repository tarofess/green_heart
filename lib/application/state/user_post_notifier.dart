import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/application/state/profile_notifier.dart';

class UserPostNotifier extends FamilyAsyncNotifier<List<PostData>, String?> {
  @override
  Future<List<PostData>> build(String? arg) async {
    final myUid = ref.read(authStateProvider).value?.uid;
    if (myUid == null || arg == null) {
      throw Exception('ユーザーが存在しないので投稿を取得できません。再度お試しください。');
    }
    final posts = await ref.read(postGetUsecaseProvider).execute(arg);
    final profile = myUid == arg
        ? ref.watch(profileNotifierProvider).value
        : await ref.read(profileGetUsecaseProvider).execute(arg);

    List<PostData> postData = [];
    for (var post in posts) {
      final commentCount =
          await ref.read(commentGetUsecaseProvider).execute(post.id);

      postData.add(PostData(
        post: post,
        userProfile: profile,
        commentCount: commentCount.length,
      ));
    }

    return postData;
  }

  Future<void> addPost(String content, List<String> selectedImages) async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('投稿ができません。アカウントがログアウトされている可能性があります。');
    }

    final addedPost = await ref.read(postAddUsecaseProvider).execute(
          uid,
          content,
          selectedImages,
        );

    final profile = await ref.read(profileGetUsecaseProvider).execute(uid);

    final newPostData = PostData(
      post: addedPost,
      userProfile: profile,
      commentCount: 0,
    );

    state = state.whenData((posts) => [newPostData, ...posts]);
  }

  Future<void> updateLikedUserIds(String postId, String userId) async {
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

  Future<void> updateCommentCount(String postId) async {
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

  Future<void> removeAllPosts() async {
    state = const AsyncValue.data([]);
  }
}

final userPostNotifierProvider =
    AsyncNotifierProviderFamily<UserPostNotifier, List<PostData>, String?>(
        UserPostNotifier.new);
