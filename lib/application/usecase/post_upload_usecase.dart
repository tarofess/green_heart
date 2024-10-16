import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';

class PostUploadUsecase {
  final PostRepository _postRepository;

  PostUploadUsecase(this._postRepository);

  Future<void> execute(Post post, String uid, List<String> paths) async {
    final imageUrls = await _postRepository.uploadImages(uid, paths);
    post = post.copyWith(imageUrls: imageUrls);
    try {
      await _postRepository.uploadPost(post);
    } catch (e) {
      // ロールバック処理
      await _postRepository.deleteImages(imageUrls);
      rethrow;
    }
  }
}
