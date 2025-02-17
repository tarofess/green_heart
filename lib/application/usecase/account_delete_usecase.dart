import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/interface/account_repository.dart';
import 'package:green_heart/application/state/account_state_notifier.dart';
import 'package:green_heart/application/usecase/account_reauth_usecase.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/domain/type/result.dart';

class AccountDeleteUsecase {
  final AccountReauthUsecase _accountReauthUsecase;
  final AccountStateNotifier _accountStateNotifier;
  final AccountRepository _accountRepository;

  AccountDeleteUsecase(
    this._accountReauthUsecase,
    this._accountStateNotifier,
    this._accountRepository,
  );

  Future<Result> execute(User? user, Profile? profile) async {
    if (profile == null || user == null) {
      return const Failure('現在アカウント情報が取得できないためアカウントを削除できません。のちほどお試しください。');
    }

    try {
      final result = await _accountReauthUsecase.execute(user);

      if (result is Failure) {
        return result;
      }

      Future.microtask(() {
        _accountStateNotifier.setAccountDeletedState(true);
      });

      await _accountRepository.deleteAccount(user);
      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
