import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';

class PostNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザーが存在しないので投稿を取得できません。再度お試しください。');
    }
    final posts = await ref.read(postGetUsecaseProvider).execute(uid);
    return posts;
  }

  void addPost(Post post) {
    state = AsyncValue.data([post, ...state.value ?? []]);
  }

  void removeAllPosts() {
    state = const AsyncValue.data([]);
  }
}
