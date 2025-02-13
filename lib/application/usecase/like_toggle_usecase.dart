import 'package:green_heart/application/interface/like_repository.dart';
import 'package:green_heart/application/state/post_manager_notifier.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/result.dart';

class LikeToggleUsecase {
  final LikeRepository _likeRepository;
  final PostManagerNotifier _postManagerNotifier;

  LikeToggleUsecase(this._likeRepository, this._postManagerNotifier);

  Future<Result> execute(
    Post post,
    String uid,
    String userName,
    String? userImage,
  ) async {
    try {
      final didLike = await _likeRepository.toggleLike(
        post.id,
        uid,
        userName,
        userImage,
      );
      _postManagerNotifier.toggleLike(post, uid, didLike);
      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
