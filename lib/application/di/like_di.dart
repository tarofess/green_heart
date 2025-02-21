import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/like_toggle_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_like_repository.dart';
import 'package:green_heart/application/state/post_manager_notifier.dart';
import 'package:green_heart/application/usecase/like_get_usecase.dart';

final likeToggleUsecaseProvider = Provider<LikeToggleUsecase>(
  (ref) => LikeToggleUsecase(
    FirebaseLikeRepository(),
    ref.read(postManagerNotifierProvider.notifier),
  ),
);

final likeGetUsecaseProvider = Provider(
  (ref) => LikeGetUsecase(FirebaseLikeRepository()),
);
