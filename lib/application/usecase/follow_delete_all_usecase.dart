import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/interface/follow_repository.dart';

class FollowDeleteAllUsecase {
  final FollowRepository _followRepository;

  FollowDeleteAllUsecase(this._followRepository);

  Future<void> execute(User user) {
    return _followRepository.deleteAllFollows(user.uid);
  }
}
