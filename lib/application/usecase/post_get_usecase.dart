import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';

class PostGetUsecase {
  final PostRepository _postRepository;

  PostGetUsecase(this._postRepository);

  Future<List<Post>> execute(String id) {
    return _postRepository.getAllPosts(id);
  }
}
