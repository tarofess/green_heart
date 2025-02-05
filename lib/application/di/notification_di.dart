import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/notification_save_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_notification_repository.dart';

final notificationSaveUsecaeProvider = Provider(
  (ref) => NotificationSaveUsecase(FirebaseNotificationRepository()),
);
