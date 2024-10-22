import 'package:green_heart/domain/type/post.dart';
import 'package:green_heart/domain/type/post_with_profile.dart';

abstract class PostRepository {
  Future<List<PostWithProfile>> getPostsByUid(String uid);
  Future<List<PostWithProfile>> getAllPosts();
  Future<void> uploadPost(Post post);
  Future<List<String>> uploadImages(String uid, List<String> paths);
  Future<void> deletePost(String postId);
  Future<void> deleteAllPostsByUid(String uid);
  Future<void> deleteImages(List<String> imageUrls);
  Future<void> deleteAllImagesByUid(String uid);
}
