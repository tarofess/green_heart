import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/post_add_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_post_repository.dart';
import 'package:green_heart/application/usecase/post_get_usecase.dart';
import 'package:green_heart/application/usecase/timeline_get_usecase.dart';
import 'package:green_heart/application/usecase/post_delete_usecase.dart';
import 'package:green_heart/application/usecase/post_search_result_get_usecase.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/state/post_manager_notifier.dart';
import 'package:green_heart/application/state/search_post_notifier.dart';
import 'package:green_heart/application/usecase/post_get_by_id_usecase.dart';
import 'package:green_heart/application/state/timeline_notifier.dart';
import 'package:green_heart/application/state/timeline_scroll_state_notifier.dart';
import 'package:green_heart/application/usecase/timeline_load_more_usecase.dart';
import 'package:green_heart/application/usecase/timeline_refresh_usecase.dart';
import 'package:green_heart/application/usecase/user_post_load_more_usecase.dart';
import 'package:green_heart/application/usecase/user_post_refresh_usecase.dart';

final postAddUsecaseProvider = Provider(
  (ref) {
    final uid = ref.watch(authStateProvider).value?.uid;
    return PostAddUsecase(
      FirebasePostRepository(ref),
      ref.read(profileGetUsecaseProvider),
      ref.read(userPostNotifierProvider(uid).notifier),
    );
  },
);

final postGetUsecaseProvider = Provider(
  (ref) => PostGetUsecase(FirebasePostRepository(ref)),
);

final postDeleteUsecaseProvider = Provider(
  (ref) => PostDeleteUsecase(
    FirebasePostRepository(ref),
    ref.read(postManagerNotifierProvider.notifier),
  ),
);

final timelineGetUsecaseProvider = Provider(
  (ref) => TimelineGetUsecase(FirebasePostRepository(ref)),
);

final timelineLoadMoreUsecaseProvider = Provider(
  (ref) => TimelineLoadMoreUsecase(
    FirebasePostRepository(ref),
    ref.read(timelineNotifierProvider.notifier),
    ref.watch(timelineScrollStateNotifierProvider),
  ),
);

final timelineRefreshUsecaseProvider = Provider(
  (ref) => TimelineRefreshUsecase(
    FirebasePostRepository(ref),
    ref.read(timelineNotifierProvider.notifier),
    ref.read(timelineScrollStateNotifierProvider.notifier),
  ),
);

final postSearchResultGetUsecaseProvider = Provider(
  (ref) => PostSearchResultGetUsecase(
    FirebasePostRepository(ref),
    ref.read(searchPostNotifierProvider.notifier),
  ),
);

final postGetByIdUsecaseProvider = Provider(
  (ref) => PostGetByIdUsecase(FirebasePostRepository(ref)),
);

final userPostLoadMoreUsecaseProvider = Provider(
  (ref) => UserPostLoadMoreUsecase(FirebasePostRepository(ref)),
);

final userPostRefreshUsecaseProvider = Provider(
  (ref) => UserPostRefreshUsecase(FirebasePostRepository(ref)),
);
