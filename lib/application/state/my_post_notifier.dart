import 'package:green_heart/application/state/base_post_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/post_data.dart';

class MyPostNotifier extends BasePostNotifier {
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

  void addPost(Post post) {
    state.whenData((currentState) {
      final updatedPosts = List<PostData>.from(currentState);
      updatedPosts.insert(
        0,
        PostData(
          post: post,
          userProfile: null,
          commentCount: 0,
        ),
      );

      state = AsyncValue.data(updatedPosts);
    });
  }

  void removeAllPosts() {
    state = const AsyncValue.data([]);
  }
}

final myPostNotifierProvider =
    AsyncNotifierProvider<MyPostNotifier, List<PostData>>(
  () => MyPostNotifier(),
);
