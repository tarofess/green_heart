import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/post_add_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_post_repository.dart';
import 'package:green_heart/application/usecase/post_get_usecase.dart';
import 'package:green_heart/application/usecase/timeline_get_usecase.dart';
import 'package:green_heart/application/usecase/comment_get_usecase.dart';
import 'package:green_heart/application/usecase/like_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_comment_repository.dart';
import 'package:green_heart/infrastructure/repository/firebase_like_repository.dart';
import 'package:green_heart/application/usecase/comment_add_usecase.dart';
import 'package:green_heart/application/usecase/comment_delete_usecase.dart';
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

final likeUsecaseProvider = Provider<LikeUsecase>(
  (ref) => LikeUsecase(FirebaseLikeRepository()),
);

final commentGetUsecaseProvider = Provider(
  (ref) => CommentGetUsecase(FirebaseCommentRepository()),
);

final commentAddUsecaseProvider = Provider(
  (ref) => CommentAddUsecase(
    FirebaseCommentRepository(),
    ref.read(userPostNotifierProvider.notifier),
  ),
);

final commentDeleteUsecaseProvider = Provider(
  (ref) => CommentDeleteUsecase(FirebaseCommentRepository()),
);
