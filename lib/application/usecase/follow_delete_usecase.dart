import 'package:green_heart/application/interface/follow_repository.dart';

class FollowDeleteUsecase {
  final FollowRepository _followRepository;

  FollowDeleteUsecase(this._followRepository);

  Future<void> execute(String uid, String followingUid) async {
    await _followRepository.unfollow(uid, followingUid);
  }
}
