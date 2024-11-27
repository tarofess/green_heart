import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';

class PostSearchResultGetUsecase {
  final PostRepository _postRepository;

  PostSearchResultGetUsecase(this._postRepository);

  Future<List<Post>> execute(String query, String? uid) async {
    return await _postRepository.getPostsBySearchWord(query, uid);
  }
}
