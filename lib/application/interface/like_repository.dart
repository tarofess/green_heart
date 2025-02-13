abstract class LikeRepository {
  Future<bool> toggleLike(
    String postId,
    String uid,
    String userName,
    String? userImage,
  );
  Future<bool> checkIfLiked(String postId, String uid);
}
