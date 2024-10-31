import 'package:green_heart/application/usecase/comment_delete_all_usecase.dart';
import 'package:green_heart/application/usecase/like_delete_all_usecase.dart';
import 'package:green_heart/application/usecase/post_delete_all_usecase.dart';
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
import 'package:green_heart/application/usecase/comment_get_reply_usecase.dart';
import 'package:green_heart/application/usecase/post_delete_usecase.dart';
import 'package:green_heart/application/usecase/report_add_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_report_repository.dart';

final postAddUsecaseProvider = Provider(
  (ref) => PostAddUsecase(FirebasePostRepository()),
);

final postGetUsecaseProvider = Provider(
  (ref) => PostGetUsecase(FirebasePostRepository()),
);

final postDeleteUsecaseProvider = Provider(
  (ref) => PostDeleteUsecase(FirebasePostRepository()),
);

final postDeleteAllUsecaseProvider = Provider(
  (ref) => PostDeleteAllUsecase(FirebasePostRepository()),
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

final likeDeleteAllUsecaseProvider = Provider(
  (ref) => LikeDeleteAllUsecase(FirebaseLikeRepository()),
);

final commentGetUsecaseProvider = Provider(
  (ref) => CommentGetUsecase(FirebaseCommentRepository()),
);

final commentAddUsecaseProvider = Provider(
  (ref) => CommentAddUsecase(FirebaseCommentRepository()),
);

final commentDeleteUsecaseProvider = Provider(
  (ref) => CommentDeleteUsecase(FirebaseCommentRepository()),
);

final commentGetReplyUsecaseProvider = Provider(
  (ref) => CommentGetReplyUsecase(FirebaseCommentRepository()),
);

final commentDeleteAllUsecaseProvider = Provider(
  (ref) => CommentDeleteAllUsecase(FirebaseCommentRepository()),
);

final reportAddUsecaseProvider = Provider(
  (ref) => ReportAddUsecase(FirebaseReportRepository()),
);
