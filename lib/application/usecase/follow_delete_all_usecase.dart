import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/follow_repository.dart';

class FollowDeleteAllUsecase {
  final FollowRepository _followRepository;

  FollowDeleteAllUsecase(this._followRepository);

  Future<void> execute(User user) async {
    try {
      return await _followRepository.deleteAllFollows(user.uid);
    } catch (e) {
      throw AppException('フォローの削除に失敗しました。再度お試しください。');
    }
  }
}
