import 'package:green_heart/application/interface/like_repository.dart';
import 'package:green_heart/application/state/post_manager_notifier.dart';
import 'package:green_heart/domain/type/post_data.dart';
import 'package:green_heart/domain/type/result.dart';

class LikeToggleUsecase {
  final LikeRepository _likeRepository;
  final PostManagerNotifier _postManagerNotifier;

  LikeToggleUsecase(this._likeRepository, this._postManagerNotifier);

  Future<Result> execute(PostData postData, String uid) async {
    try {
      await _likeRepository.toggleLike(postData.post.id, uid);
      _postManagerNotifier.toggleLike(postData, uid);
      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
