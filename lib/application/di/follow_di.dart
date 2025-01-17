import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/infrastructure/repository/firebase_follow_repository.dart';
import 'package:green_heart/application/usecase/following_check_usecase.dart';
import 'package:green_heart/application/usecase/following_get_usecase.dart';
import 'package:green_heart/application/usecase/follower_get_usecase.dart';
import 'package:green_heart/application/usecase/follow_delete_all_usecase.dart';
import 'package:green_heart/application/usecase/follow_usecase.dart';
import 'package:green_heart/application/usecase/unfollow_usecase.dart';

final followCheckUsecaseProvider = Provider(
  (ref) => FollowingCheckUsecase(FirebaseFollowRepository()),
);

final followingGetUsecaseProvider = Provider(
  (ref) => FollowingGetUsecase(FirebaseFollowRepository()),
);

final followerGetUsecaseProvider = Provider(
  (ref) => FollowerGetUsecase(FirebaseFollowRepository()),
);

final followDeleteAllUsecaseProvider = Provider(
  (ref) => FollowDeleteAllUsecase(FirebaseFollowRepository()),
);

final followUsecaseProvider = Provider(
  (ref) => FollowUsecase(FirebaseFollowRepository()),
);

final unfollowUsecaseProvider = Provider(
  (ref) => UnfollowUsecase(FirebaseFollowRepository()),
);
