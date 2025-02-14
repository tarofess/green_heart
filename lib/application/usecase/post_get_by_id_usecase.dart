import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';

class PostGetByIdUsecase {
  final PostRepository _postRepository;

  PostGetByIdUsecase(this._postRepository);

  Future<List<Post>> execute(String postId) async {
    try {
      final post = await _postRepository.getPostById(postId);
      return post;
    } catch (e) {
      rethrow;
    }
  }
}
