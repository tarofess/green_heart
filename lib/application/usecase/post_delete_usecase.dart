import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/application/state/post_manager_notifier.dart';
import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/result.dart';

class PostDeleteUsecase {
  final PostRepository _postRepository;
  final PostManagerNotifier _postManagerNotifier;

  PostDeleteUsecase(this._postRepository, this._postManagerNotifier);

  Future<Result> execute(Post post, String uid) async {
    try {
      await _postRepository.deletePost(post.id);
      _postManagerNotifier.deletePost(uid, post);

      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
