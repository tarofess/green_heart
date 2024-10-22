import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/like_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_like_repository.dart';

final likeUsecaseProvider = Provider<LikeUsecase>(
  (ref) => LikeUsecase(FirebaseLikeRepository()),
);
