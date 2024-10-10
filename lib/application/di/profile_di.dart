import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/profile_get_usecase.dart';
import 'package:green_heart/application/usecase/profile_image_upload_usecase.dart';
import 'package:green_heart/application/usecase/profile_save_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_profile_repository.dart';

final profileSaveUsecaseProvider = Provider(
  (ref) => ProfileSaveUsecase(FirebaseProfileRepository()),
);

final profileGetUsecaseProvider = Provider(
  (ref) => ProfileGetUsecase(FirebaseProfileRepository()),
);

final profileImageUploadUsecaseProvider = Provider(
  (ref) => ProfileImageUploadUsecase(FirebaseProfileRepository()),
);