import 'package:green_heart/domain/type/follow.dart';

abstract class FollowRepository {
  Future<Follow> follow(String uid, String followingUid);
  Future<void> unfollow(String uid, String followingUid);
  Future<bool> isFollowing(String uid, String followingUid);
  Future<List<Follow>> getFollowers(String uid);
  Future<List<Follow>> getFollowing(String uid);
}
