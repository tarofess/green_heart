import 'package:green_heart/domain/type/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPostsByUid(String uid);
  Future<List<Post>> getAllPosts();
  Future<Post> uploadPost(String uid, String content, List<String> imageUrls);
  Future<List<String>> uploadImages(String uid, List<String> paths);
  Future<void> deletePost(String postId);
  Future<void> deleteAllPostsByUid(String uid);
  Future<void> deleteImages(List<String> imageUrls);
  Future<void> deleteAllImagesByUid(String uid);
}
