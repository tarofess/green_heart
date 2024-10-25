import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/post_add_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_post_repository.dart';
import 'package:green_heart/application/usecase/post_get_usecase.dart';
import 'package:green_heart/application/usecase/timeline_get_usecase.dart';
import 'package:green_heart/application/usecase/comment_get_usecase.dart';
import 'package:green_heart/application/usecase/like_toggle_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_comment_repository.dart';
import 'package:green_heart/infrastructure/repository/firebase_like_repository.dart';
import 'package:green_heart/application/usecase/comment_add_usecase.dart';
import 'package:green_heart/application/usecase/comment_delete_usecase.dart';
import 'package:green_heart/application/usecase/like_get_usecase.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';

final postAddUsecaseProvider = Provider(
  (ref) => PostAddUsecase(FirebasePostRepository()),
);

final postGetUsecaseProvider = Provider(
  (ref) => PostGetUsecase(FirebasePostRepository()),
);

final timelineGetUsecaseProvider = Provider(
  (ref) => TimelineGetUsecase(FirebasePostRepository()),
);

final likeGetUsecaseProvider = Provider(
  (ref) => LikeGetUsecase(FirebaseLikeRepository()),
);

final likeToggleUsecaseProvider = Provider<LikeToggleUsecase>(
  (ref) => LikeToggleUsecase(FirebaseLikeRepository()),
);

final commentGetUsecaseProvider = Provider(
  (ref) => CommentGetUsecase(FirebaseCommentRepository()),
);

final commentAddUsecaseProvider = Provider(
  (ref) => CommentAddUsecase(
    FirebaseCommentRepository(),
    ref.read(userPostNotifierProvider(ref.watch(authStateProvider).value?.uid)
        .notifier),
    ref.read(timelineNotifierProvider.notifier),
  ),
);

final commentDeleteUsecaseProvider = Provider(
  (ref) => CommentDeleteUsecase(FirebaseCommentRepository()),
);
