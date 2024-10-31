import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_heart/application/interface/post_repository.dart';

class PostDeleteAllUsecase {
  final PostRepository _postRepository;

  PostDeleteAllUsecase(this._postRepository);

  Future<void> execute(User user) async {
    final deleteTasks = Future.wait([
      _postRepository.deleteAllPostsByUid(user.uid),
      _postRepository.deleteAllImagesByUid(user.uid),
    ]);
    await deleteTasks;
  }
}
