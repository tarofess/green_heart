import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/domain/type/account_state.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';

class AccountStateNotifier extends AsyncNotifier<AccountState> {
  @override
  Future<AccountState> build() async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      return const AccountState(isRegistered: false, isDeleted: false);
    }

    final profile = await ref.read(profileGetUsecaseProvider).execute(uid);
    return profile == null
        ? const AccountState(isRegistered: false, isDeleted: false)
        : const AccountState(isRegistered: true, isDeleted: false);
  }

  void setRegisteredState(bool isRegistered) {
    state = state.whenData(
      (accountState) => accountState.copyWith(isRegistered: isRegistered),
    );
  }

  void setAccountDeletedState(bool isDeleted) {
    state = state.whenData(
      (accountState) => accountState.copyWith(isDeleted: isDeleted),
    );
  }
}

final accountStateNotifierProvider =
    AsyncNotifierProvider<AccountStateNotifier, AccountState>(
  () => AccountStateNotifier(),
);
