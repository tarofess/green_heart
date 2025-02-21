import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/notification_get_usecase.dart';
import 'package:green_heart/application/usecase/notification_mark_as_read_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_notification_repository.dart';
import 'package:green_heart/application/state/notification_notifier.dart';
import 'package:green_heart/application/usecase/notification_delete_usecase.dart';
import 'package:green_heart/application/usecase/notification_load_more_usecase.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/notification_scroll_state_notifier.dart';
import 'package:green_heart/application/usecase/notification_refresh_usecase.dart';

final notificationGetUsecaseProvider = Provider(
  (ref) => NotificationGetUsecase(
    FirebaseNotificationRepository(ref),
  ),
);

final notificationMarkAsReadUsecaseProvider = Provider(
  (ref) => NotificationMarkAsReadUsecase(
    FirebaseNotificationRepository(ref),
    ref.read(notificationNotifierProvider.notifier),
  ),
);

final notificationDeleteUsecaseProvider = Provider(
  (ref) => NotificationDeleteUsecase(
    FirebaseNotificationRepository(ref),
    ref.read(notificationNotifierProvider.notifier),
  ),
);

final notificationLoadMoreUsecaseProvider = Provider(
  (ref) => NotificationLoadMoreUsecase(
    FirebaseNotificationRepository(ref),
    ref.read(notificationNotifierProvider.notifier),
    ref.watch(authStateProvider).value?.uid,
  ),
);

final notificationRefreshUsecaseProvider = Provider(
  (ref) => NotificationRefreshUsecase(
    FirebaseNotificationRepository(ref),
    ref.read(notificationNotifierProvider.notifier),
    ref.read(notificationScrollStateNotifierProvider.notifier),
    ref.watch(authStateProvider).value?.uid,
  ),
);
