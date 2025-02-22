import 'package:green_heart/domain/type/post.dart';

abstract class PostRepository {
  Future<Post> addPost(
    String postId,
    String uid,
    String content,
    List<String> imageUrls,
    String userName,
    String? userImage,
    DateTime selectedDay,
  );
  Future<List<Post>> getDiaryPostsByUid(String uid);
  Future<List<Post>> getTimelinePosts();
  Future<List<Post>> getPostsBySearchWord(String searchWord, String? uid);
  Future<List<Post>> getPostById(String postId);
  Future<(String postId, List<String>)> uploadImages(
      String uid, List<String> paths);
  Future<void> deletePost(String postId);
}
