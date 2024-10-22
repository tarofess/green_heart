import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';

class PostUploadUsecase {
  final PostRepository _postRepository;

  PostUploadUsecase(this._postRepository);

  Future<Post> execute(
    String uid,
    String content,
    List<String> paths,
  ) async {
    final imageUrls = await _postRepository.uploadImages(uid, paths);
    final post = await _postRepository.uploadPost(uid, content, imageUrls);
    return post;
  }
}
