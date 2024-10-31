import 'package:green_heart/domain/type/like.dart';

abstract class LikeRepository {
  Future<void> toggleLike(String postId, String userId);
  Future<List<Like>> getLikes(String postId);
  Future<void> deleteAllLikesByUid(String uid);
}
