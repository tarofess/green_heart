import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_heart/application/di/account_di.dart';
import 'package:green_heart/application/usecase/account_delete_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/profile_notifier_provider.dart';
import 'package:green_heart/domain/type/profile.dart';

class AccountPageViewModel {
  final Profile? _profile;
  final User? _user;
  final AccountDeleteUsecase _accountDeleteUsecase;

  AccountPageViewModel(this._profile, this._user, this._accountDeleteUsecase);

  Future<void> deleteAccount() async {
    if (_profile == null || _user == null) {
      throw Exception('現在アカウントを削除できません。のちほどお試しください。');
    }

    await _accountDeleteUsecase.execute(_user);
  }
}

final accountPageViewModelProvider = Provider((ref) => AccountPageViewModel(
      ref.read(profileNotifierProvider).value,
      ref.watch(authStateProvider).value,
      ref.read(accountDeleteUsecaseProvider),
    ));
