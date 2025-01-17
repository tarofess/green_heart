import 'package:green_heart/application/interface/follow_repository.dart';
import 'package:green_heart/application/state/following_notifier.dart';
import 'package:green_heart/application/state/user_page_state_notifier.dart';
import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/domain/type/user_page_state.dart';

class FollowUsecase {
  final FollowRepository _followRepository;

  FollowUsecase(this._followRepository);

  Future<Result> execute(
    String? myUid,
    String? targetUid,
    UserPageState userPageState,
    FollowingNotifier followingNotifier,
    UserPageStateNotifier userPageStateNotifier,
  ) async {
    if (myUid == null || targetUid == null) {
      return const Failure('ユーザーが存在しないためフォローできませんでした。');
    }

    try {
      if (userPageState.isFollowing) {
        await _followRepository.unfollow(myUid, targetUid);
        followingNotifier.unfollow(myUid, targetUid);
        userPageStateNotifier.setIsFollowing(false);
      } else {
        final newFollow = await _followRepository.follow(myUid, targetUid);
        await followingNotifier.follow(myUid, targetUid, newFollow);
        userPageStateNotifier.setIsFollowing(true);
      }
      return const Success(null);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
