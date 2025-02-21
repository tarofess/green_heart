import 'package:green_heart/application/interface/like_repository.dart';
import 'package:green_heart/domain/type/like.dart';

class LikeGetUsecase {
  final LikeRepository _likeRepository;

  LikeGetUsecase(this._likeRepository);

  Future<List<Like>> execute(String uid) {
    return _likeRepository.getLikes(uid);
  }
}
