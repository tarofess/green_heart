import 'package:green_heart/application/interface/like_repository.dart';

class LikeToggleUsecase {
  final LikeRepository _likeRepository;

  LikeToggleUsecase(this._likeRepository);

  Future<void> execute(String postId, String userId) async {
    await _likeRepository.toggleLike(postId, userId);
  }
}
