import 'package:green_heart/application/interface/like_repository.dart';

class LikeUsecase {
  final LikeRepository _likeRepository;

  LikeUsecase(this._likeRepository);

  Future<void> execute(String postId, String userId) async {
    await _likeRepository.toggleLike(postId, userId);
  }
}
