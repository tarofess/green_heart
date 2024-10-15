import 'package:green_heart/application/interface/post_repository.dart';
import 'package:green_heart/domain/type/post.dart';

class PostUploadUsecase {
  final PostRepository _postRepository;

  PostUploadUsecase(this._postRepository);

  Future<void> execute(Post post, String uid, List<String> paths) async {
    try {
      final imageUrls = await _postRepository.uploadImages(uid, paths);
      post = post.copyWith(imageUrls: imageUrls);
      await _postRepository.uploadPost(post);
    } catch (e) {
      throw Exception('投稿に失敗しました。再度お試しください。');
    }
  }
}
