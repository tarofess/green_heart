import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/comment_add_usecase.dart';
import 'package:green_heart/application/usecase/comment_delete_usecase.dart';
import 'package:green_heart/application/usecase/comment_get_reply_usecase.dart';
import 'package:green_heart/application/usecase/comment_get_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_comment_repository.dart';

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
