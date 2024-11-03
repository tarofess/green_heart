import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/like_delete_all_usecase.dart';
import 'package:green_heart/application/usecase/like_get_usecase.dart';
import 'package:green_heart/application/usecase/like_toggle_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_like_repository.dart';

final likeGetUsecaseProvider = Provider(
  (ref) => LikeGetUsecase(FirebaseLikeRepository()),
);

final likeToggleUsecaseProvider = Provider<LikeToggleUsecase>(
  (ref) => LikeToggleUsecase(FirebaseLikeRepository()),
);

final likeDeleteAllUsecaseProvider = Provider(
  (ref) => LikeDeleteAllUsecase(FirebaseLikeRepository()),
);
