import 'package:green_heart/application/interface/follow_repository.dart';
import 'package:green_heart/domain/type/follow.dart';

class FollowerGetUsecase {
  final FollowRepository _followRepository;

  FollowerGetUsecase(this._followRepository);

  Future<List<Follow>> execute(String uid) {
    return _followRepository.getFollowers(uid);
  }
}
