import 'package:green_heart/application/di/post_di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/post.dart';

class TimelineNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    final posts = await ref.read(timelineGetUsecaseProvider).execute();
    return posts;
  }

  void addPost(Post post) {
    state = AsyncValue.data([post, ...state.value ?? []]);
  }
}
