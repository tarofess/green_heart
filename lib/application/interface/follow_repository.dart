import 'package:green_heart/domain/type/follow.dart';

abstract class FollowRepository {
  Future<void> follow(
    String uid,
    String targetUid,
    Follow follow,
    Follow follower,
  );
  Future<void> unfollow(String uid, String targetUid);
  Future<bool> isFollowing(String uid, String targetUid);
  Future<List<Follow>> getFollowers(String uid);
  Future<List<Follow>> getFollows(String uid);
}
