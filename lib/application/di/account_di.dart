import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/account_delete_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_account_repository.dart';
import 'package:green_heart/application/di/auth_di.dart';
import 'package:green_heart/application/di/comment_di.dart';
import 'package:green_heart/application/di/follow_di.dart';
import 'package:green_heart/application/di/like_di.dart';
import 'package:green_heart/application/di/notification_di.dart';
import 'package:green_heart/application/di/post_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/state/account_state_notifier.dart';

final accountDeleteUsecaseProvider = Provider(
  (ref) => AccountDeleteUsecase(
    ref.read(accountReauthUsecaseProvider),
    ref.read(notificationDeleteUsecaseProvider),
    ref.read(likeDeleteAllUsecaseProvider),
    ref.read(commentDeleteAllUsecaseProvider),
    ref.read(followDeleteAllUsecaseProvider),
    ref.read(profileDeleteUsecaseProvider),
    ref.read(postDeleteAllUsecaseProvider),
    ref.read(accountStateNotifierProvider.notifier),
    FirebaseAccountRepository(),
  ),
);
