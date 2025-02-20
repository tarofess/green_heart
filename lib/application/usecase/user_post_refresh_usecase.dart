import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/application/state/user_post_scroll_state_notifier.dart';
import 'package:green_heart/domain/type/result.dart';

class UserPostRefreshUsecase {
  final PostRepository _postRepository;

  UserPostRefreshUsecase(this._postRepository);

  Future<Result> execute(
    String? uid,
    final UserPostNotifier userPostNotifier,
    final UserPostScrollStateNotifier userPostScrollStateNotifier,
  ) async {
    try {
      if (uid == null) {
        throw Exception('ユーザーの投稿を取得できません。再度お試しください。');
      }

      userPostScrollStateNotifier.reset();

      final posts = await _postRepository.getDiaryPostsByUid(uid);
      await userPostNotifier.refresh(uid, posts);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
