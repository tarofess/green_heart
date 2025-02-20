import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/domain/type/user_post_scroll_state.dart';

class UserPostLoadMoreUsecase {
  final PostRepository _postRepository;

  UserPostLoadMoreUsecase(this._postRepository);

  Future<Result> execute(
    String? uid,
    final UserPostScrollState userPostScrollState,
    final UserPostNotifier userPostNotifier,
  ) async {
    if (uid == null) {
      return const Failure('ユーザーの投稿を取得できません。再度お試しください。');
    }

    try {
      if (!userPostScrollState.hasMore) return const Success();

      final posts = await _postRepository.getDiaryPostsByUid(uid);
      await userPostNotifier.loadMore(posts);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
