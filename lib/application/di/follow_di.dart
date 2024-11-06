import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/follow_add_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_follow_repository.dart';
import 'package:green_heart/application/usecase/follow_check_usecase.dart';
import 'package:green_heart/application/usecase/follow_delete_usecase.dart';

final followAddUsecaseProvider = Provider(
  (ref) => FollowAddUsecase(FirebaseFollowRepository()),
);

final followDeleteUsecaseProvider = Provider(
  (ref) => FollowDeleteUsecase(FirebaseFollowRepository()),
);

final followCheckUsecaseProvider = Provider(
  (ref) => FollowCheckUsecase(FirebaseFollowRepository()),
);
