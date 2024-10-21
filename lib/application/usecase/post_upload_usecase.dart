import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';

class PostUploadUsecase {
  final PostRepository _postRepository;

  PostUploadUsecase(this._postRepository);

  Future<List<String>> execute(
      Post post, String uid, List<String> paths) async {
    final imageUrls = await _postRepository.uploadImages(uid, paths);
    post = post.copyWith(imageUrls: imageUrls);
    await _postRepository.uploadPost(post);
    return imageUrls;
  }
}
