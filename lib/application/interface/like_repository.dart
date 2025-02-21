import 'package:green_heart/domain/type/like.dart';

abstract class LikeRepository {
  Future<List<Like>> getLikes(String uid);
  Future<bool> toggleLike(
    String postId,
    String uid,
    String userName,
    String? userImage,
  );
}
