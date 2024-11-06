import 'package:green_heart/application/interface/follow_repository.dart';
import 'package:green_heart/domain/type/follow.dart';

class FollowingAddUsecase {
  final FollowRepository _followRepository;

  FollowingAddUsecase(this._followRepository);

  Future<Follow> execute(String uid, String followingUid) async {
    return await _followRepository.follow(uid, followingUid);
  }
}
