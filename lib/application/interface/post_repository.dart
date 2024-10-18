import 'package:green_heart/domain/type/post.dart';

abstract class PostRepository {
  Future<void> uploadPost(Post post);
  Future<List<String>> uploadImages(String uid, List<String> paths);
  Future<void> deletePost(String postId);
  Future<void> deleteAllPosts(String uid);
  Future<void> deleteImages(List<String> imageUrls);
  Future<void> deleteAllImages(String uid);
}
