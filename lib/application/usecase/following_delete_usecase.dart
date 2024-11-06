import 'package:green_heart/application/interface/follow_repository.dart';

class FollowingDeleteUsecase {
  final FollowRepository _followRepository;

  FollowingDeleteUsecase(this._followRepository);

  Future<void> execute(String uid, String followingUid) async {
    await _followRepository.unfollow(uid, followingUid);
  }
}
