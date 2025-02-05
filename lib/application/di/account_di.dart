import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/account_delete_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_account_repository.dart';
import 'package:green_heart/application/di/auth_di.dart';
import 'package:green_heart/application/state/account_state_notifier.dart';

final accountDeleteUsecaseProvider = Provider(
  (ref) => AccountDeleteUsecase(
    ref.read(accountReauthUsecaseProvider),
    ref.read(accountStateNotifierProvider.notifier),
    FirebaseAccountRepository(),
  ),
);
