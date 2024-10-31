import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_heart/application/interface/like_repository.dart';

class LikeDeleteAllUsecase {
  final LikeRepository _likeRepository;

  LikeDeleteAllUsecase(this._likeRepository);

  Future<void> execute(User user) {
    return _likeRepository.deleteAllLikesByUid(user.uid);
  }
}
