import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/interface/account_repository.dart';

class AccountDeleteUsecase {
  final AccountRepository _accountRepository;

  AccountDeleteUsecase(this._accountRepository);

  Future<void> execute(User user) async {
    await _accountRepository.deleteAccount(user);
  }
}
