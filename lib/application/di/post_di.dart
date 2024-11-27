import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/post_add_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_post_repository.dart';
import 'package:green_heart/application/usecase/post_get_usecase.dart';
import 'package:green_heart/application/usecase/timeline_get_usecase.dart';
import 'package:green_heart/application/usecase/post_delete_usecase.dart';
import 'package:green_heart/application/usecase/post_delete_all_usecase.dart';
import 'package:green_heart/application/usecase/post_search_result_get_usecase.dart';

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

final postSearchResultGetUsecaseProvider = Provider(
  (ref) => PostSearchResultGetUsecase(FirebasePostRepository()),
);
