import 'package:green_heart/application/interface/post_repository.dart';

class PostDeleteUsecase {
  final PostRepository _postRepository;

  PostDeleteUsecase(this._postRepository);

  Future<void> execute(String postId) async {
    await _postRepository.deletePost(postId);
  }
}
