import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/shared_pref_di.dart';
import 'package:green_heart/application/usecase/fcm_token_save_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_notification_repository.dart';

final fcmTokenSaveUsecaeProvider = Provider(
  (ref) => FcmTokenSaveUsecase(
    FirebaseNotificationRepository(),
    ref.read(stringGetSharedPrefUsecaseProvider),
    ref.read(stringSaveSharedPrefUsecaseProvider),
  ),
);
