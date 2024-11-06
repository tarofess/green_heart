import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/follow_repository.dart';

class FollowCheckUsecase {
  final FollowRepository _followRepository;

  FollowCheckUsecase(this._followRepository);

  Future<bool> execute(String? uid, String followingUid) async {
    if (uid == null) {
      throw AppException('ユーザーの情報が取得できません。再度お試しください。');
    }
    return await _followRepository.isFollowing(uid, followingUid);
  }
}
