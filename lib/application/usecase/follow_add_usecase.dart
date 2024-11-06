import 'package:green_heart/application/interface/follow_repository.dart';
import 'package:green_heart/domain/type/follow.dart';

class FollowAddUsecase {
  final FollowRepository _followRepository;

  FollowAddUsecase(this._followRepository);

  Future<Follow> execute(String uid, String followingUid) async {
    return await _followRepository.follow(uid, followingUid);
  }
}
