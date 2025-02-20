import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/notification_get_usecase.dart';
import 'package:green_heart/application/usecase/notification_mark_as_read_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_notification_repository.dart';
import 'package:green_heart/application/state/notification_notifier.dart';
import 'package:green_heart/application/usecase/notification_delete_usecase.dart';

final notificationGetUsecaseProvider = Provider(
  (ref) => NotificationGetUsecase(
    FirebaseNotificationRepository(),
  ),
);

final notificationMarkAsReadUsecaseProvider = Provider(
  (ref) => NotificationMarkAsReadUsecase(
    FirebaseNotificationRepository(),
    ref.read(notificationNotifierProvider.notifier),
  ),
);

final notificationDeleteUsecaseProvider = Provider(
  (ref) => NotificationDeleteUsecase(
    FirebaseNotificationRepository(),
    ref.read(notificationNotifierProvider.notifier),
  ),
);
