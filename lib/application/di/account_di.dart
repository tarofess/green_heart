import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/account_delete_usecase.dart';
import 'package:green_heart/application/state/profile_notifier_provider.dart';
import 'package:green_heart/infrastructure/repository/firebase_notification_repository.dart';
import 'package:green_heart/infrastructure/repository/firebase_account_repository.dart';
import 'package:green_heart/infrastructure/repository/firebase_post_repository.dart';
import 'package:green_heart/infrastructure/repository/firebase_profile_repository.dart';
import 'package:green_heart/application/di/auth_di.dart';
import 'package:green_heart/application/state/post_notifier_provider.dart';

final accountDeleteUsecaseProvider = Provider((ref) => AccountDeleteUsecase(
      ref.watch(authServiceProvider),
      FirebaseAccountRepository(),
      FirebaseProfileRepository(),
      FirebasePostRepository(),
      FirebaseNotificationRepository(),
      ref.read(profileNotifierProvider.notifier),
      ref.read(signOutUseCaseProvider),
      ref.read(postNotifierProvider.notifier),
    ));
