import 'package:green_heart/application/interface/follow_repository.dart';

class FollowDeleteAllUsecase {
  final FollowRepository _followRepository;

  FollowDeleteAllUsecase(this._followRepository);

  Future<void> execute(String uid) {
    return _followRepository.deleteAllFollows(uid);
  }
}
