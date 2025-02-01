import 'package:green_heart/application/interface/follow_repository.dart';
import 'package:green_heart/application/state/follow_notifier.dart';
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
    FollowNotifier myFollowNotifier,
    FollowNotifier targetFollowNotifier,
    UserPageStateNotifier userPageStateNotifier,
  ) async {
    if (myUid == null || targetUid == null) {
      return const Failure('ユーザーが存在しないためフォロー解除できませんでした。');
    }

    try {
      await _followRepository.unfollow(myUid, targetUid);
      myFollowNotifier.unfollow(myUid, targetUid);
      await _followRepository.unfollow(targetUid, myUid);
      targetFollowNotifier.unfollow(targetUid, myUid);
      userPageStateNotifier.setIsFollowing(false);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
