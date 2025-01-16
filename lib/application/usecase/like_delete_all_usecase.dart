import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/like_repository.dart';

class LikeDeleteAllUsecase {
  final LikeRepository _likeRepository;

  LikeDeleteAllUsecase(this._likeRepository);

  Future<void> execute(User user) {
    try {
      return _likeRepository.deleteAllLikesByUid(user.uid);
    } catch (e) {
      throw AppException('いいねの削除に失敗しました。再度お試しください。');
    }
  }
}
