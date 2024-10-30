import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/account_state.dart';
import 'package:green_heart/application/di/shared_pref_di.dart';

class AccountStateNotifier extends Notifier<AccountState> {
  @override
  AccountState build() {
    return const AccountState(isRegistered: false, isDeleted: false);
  }

  void setRegisteredState(bool isRegistered) {
    state = state.copyWith(isRegistered: isRegistered);
  }

  void setAccountDeletedState(bool isDeleted) {
    state = state.copyWith(isDeleted: isDeleted);
  }

  Future<void> checkIfFirstTimeUser() async {
    final uid = await ref.read(sharedPrefGetUsecaseProvider).execute('uid');
    if (uid == null) return;

    final isRegistered = uid.isNotEmpty;
    setRegisteredState(isRegistered);
  }
}

final accountStateNotifierProvider =
    NotifierProvider<AccountStateNotifier, AccountState>(
  () => AccountStateNotifier(),
);
