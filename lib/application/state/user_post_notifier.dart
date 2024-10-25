import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/application/state/base_post_notifier.dart';

class UserPostNotifier extends BasePostNotifier {
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

  void removeAllPosts() {
    state = const AsyncValue.data([]);
  }
}

final userPostNotifierProvider =
    AsyncNotifierProvider<UserPostNotifier, List<PostData>>(
  () => UserPostNotifier(),
);
