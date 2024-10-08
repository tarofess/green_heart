import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/application/usecase/profile_get_usecase.dart';
import 'package:green_heart/application/usecase/profile_image_upload_usecase.dart';
import 'package:green_heart/application/usecase/profile_save_usecase.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/infrastructure/repository/firebase_profile_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final profileNotifierProvider =
    AsyncNotifierProvider<ProfileNotifier, Profile?>(() => ProfileNotifier());

final profileSaveUsecaseProvider = Provider(
  (ref) => ProfileSaveUsecase(FirebaseProfileRepository()),
);

final profileGetUsecaseProvider = Provider(
  (ref) => ProfileGetUsecase(FirebaseProfileRepository()),
);

final profileImageUploadUsecaseProvider = Provider(
  (ref) => ProfileImageUploadUsecase(FirebaseProfileRepository()),
);
