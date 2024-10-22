import 'package:green_heart/application/state/base_post_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/domain/type/post_with_profile.dart';

class MyPostNotifier extends BasePostNotifier {
  @override
  Future<List<PostWithProfile>> build() async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('ユーザーが存在しないので投稿を取得できません。再度お試しください。');
    }
    final posts = await ref.read(postGetUsecaseProvider).execute(uid);
    return posts;
  }

  void removeAllPosts() {
    state = const AsyncValue.data([]);
  }
}

final myPostNotifierProvider =
    AsyncNotifierProvider<MyPostNotifier, List<PostWithProfile>>(
  () => MyPostNotifier(),
);
