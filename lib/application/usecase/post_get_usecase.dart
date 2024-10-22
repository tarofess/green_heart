import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post_with_profile.dart';

class PostGetUsecase {
  final PostRepository _postRepository;

  PostGetUsecase(this._postRepository);

  Future<List<PostWithProfile>> execute(String id) {
    return _postRepository.getPostsByUid(id);
  }
}
