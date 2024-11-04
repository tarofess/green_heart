import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/interface/account_repository.dart';
import 'package:green_heart/application/usecase/signout_usecase.dart';

class AccountDeleteUsecase {
  final AccountRepository _accountRepository;
  final SignOutUseCase _signOutUseCase;

  AccountDeleteUsecase(this._accountRepository, this._signOutUseCase);

  Future<void> execute(User user) async {
    try {
      await _accountRepository.deleteAccount(user);
    } catch (e) {
      _signOutUseCase.execute();
    }
  }
}
