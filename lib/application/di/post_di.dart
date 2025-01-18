import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/post_add_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_post_repository.dart';
import 'package:green_heart/application/usecase/post_get_usecase.dart';
import 'package:green_heart/application/usecase/timeline_get_usecase.dart';
import 'package:green_heart/application/usecase/post_delete_usecase.dart';
import 'package:green_heart/application/usecase/post_delete_all_usecase.dart';
import 'package:green_heart/application/usecase/post_search_result_get_usecase.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/state/post_manager_notifier.dart';
import 'package:green_heart/application/state/search_post_notifier.dart';

final postAddUsecaseProvider = Provider(
  (ref) {
    final uid = ref.watch(authStateProvider).value?.uid;
    return PostAddUsecase(
      FirebasePostRepository(),
      ref.read(profileGetUsecaseProvider),
      ref.read(userPostNotifierProvider(uid).notifier),
    );
  },
);

final postGetUsecaseProvider = Provider(
  (ref) => PostGetUsecase(FirebasePostRepository()),
);

final postDeleteUsecaseProvider = Provider(
  (ref) => PostDeleteUsecase(
    FirebasePostRepository(),
    ref.read(postManagerNotifierProvider.notifier),
  ),
);

final postDeleteAllUsecaseProvider = Provider(
  (ref) => PostDeleteAllUsecase(FirebasePostRepository()),
);

final timelineGetUsecaseProvider = Provider(
  (ref) => TimelineGetUsecase(FirebasePostRepository()),
);

final postSearchResultGetUsecaseProvider = Provider(
  (ref) => PostSearchResultGetUsecase(
    FirebasePostRepository(),
    ref.read(searchPostNotifierProvider.notifier),
  ),
);
