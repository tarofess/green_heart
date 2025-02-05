abstract class LikeRepository {
  Future<bool> toggleLike(String postId, String userId);
  Future<bool> checkIfLiked(String postId, String uid);
}
