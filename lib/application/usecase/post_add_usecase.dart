import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';

class PostAddUsecase {
  final PostRepository _postRepository;

  PostAddUsecase(this._postRepository);

  Future<Post> execute(
    String uid,
    String content,
    List<String> paths,
    DateTime selectedDay,
  ) async {
    final imageUrls = await _postRepository.uploadImages(uid, paths);
    final post = await _postRepository.addPost(
      uid,
      content,
      imageUrls,
      selectedDay,
    );
    return post;
  }
}
