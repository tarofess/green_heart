import 'package:green_heart/application/interface/like_repository.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class LikeCheckUsecase {
  final LikeRepository _likeRepository;

  LikeCheckUsecase(this._likeRepository);

  Future<bool> execute(String postId, String uid) async {
    try {
      return await _likeRepository.checkIfLiked(postId, uid);
    } catch (e, stackTrace) {
      await ExceptionHandler.handleException(e, stackTrace);
      return false;
    }
  }
}
