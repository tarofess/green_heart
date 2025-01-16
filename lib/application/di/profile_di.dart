import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/profile_get_usecase.dart';
import 'package:green_heart/application/usecase/profile_save_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_profile_repository.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/application/usecase/profile_delete_usecase.dart';

final profileSaveUsecaseProvider = Provider(
  (ref) {
    final uid = ref.watch(authStateProvider).value?.uid;
    return ProfileSaveUsecase(
      FirebaseProfileRepository(),
      ref.watch(profileNotifierProvider.notifier),
      ref.watch(userPostNotifierProvider(uid).notifier),
    );
  },
);

final profileGetUsecaseProvider = Provider(
  (ref) => ProfileGetUsecase(FirebaseProfileRepository()),
);

final profileDeleteUsecaseProvider = Provider(
  (ref) => ProfileDeleteUsecase(FirebaseProfileRepository()),
);
