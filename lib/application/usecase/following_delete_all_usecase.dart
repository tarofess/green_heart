import 'package:green_heart/application/interface/follow_repository.dart';

class FollowingDeleteAllUsecase {
  final FollowRepository _followRepository;

  FollowingDeleteAllUsecase(this._followRepository);

  Future<void> execute(String uid) async {
    return _followRepository.deleteAllFollowing(uid);
  }
}
