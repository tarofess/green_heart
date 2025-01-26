import 'package:green_heart/application/interface/follow_repository.dart';
import 'package:green_heart/application/state/following_notifier.dart';
import 'package:green_heart/application/state/user_page_state_notifier.dart';
import 'package:green_heart/domain/type/result.dart';
import 'package:green_heart/domain/type/user_page_state.dart';

class UnfollowUsecase {
  final FollowRepository _followRepository;

  UnfollowUsecase(this._followRepository);

  Future<Result> execute(
    String? myUid,
    String? targetUid,
    UserPageState userPageState,
    FollowingNotifier myFollowingNotifier,
    FollowingNotifier targetFollowingNotifier,
    UserPageStateNotifier userPageStateNotifier,
  ) async {
    if (myUid == null || targetUid == null) {
      return const Failure('ユーザーが存在しないためフォロー解除できませんでした。');
    }

    try {
      await _followRepository.unfollow(myUid, targetUid);
      myFollowingNotifier.unfollow(myUid, targetUid);
      await _followRepository.unfollow(targetUid, myUid);
      targetFollowingNotifier.unfollow(targetUid, myUid);
      userPageStateNotifier.setIsFollowing(false);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
