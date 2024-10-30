import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/application/di/account_di.dart';
import 'package:green_heart/domain/type/account_info.dart';
import 'package:green_heart/domain/util/date_util.dart';

class AccountNotifier extends Notifier<AccountInfo> {
  @override
  AccountInfo build() {
    final providerName = getProviderName();
    final email = getEmail();
    final creationTime = getRegistrationDate();

    return AccountInfo(
      providerName: providerName,
      email: email,
      registrationDate: creationTime,
    );
  }

  String getProviderName() {
    switch (ref.watch(authStateProvider).value?.providerData.first.providerId) {
      case 'google.com':
        return 'Google';
      case 'apple.com':
        return 'Apple';
      default:
        return '不明';
    }
  }

  String getEmail() {
    return ref.watch(authStateProvider).value?.email ?? '不明';
  }

  String getRegistrationDate() {
    final regDate = ref.watch(profileNotifierProvider).value?.createdAt;
    return regDate == null
        ? '不明'
        : DateUtil.formatAccountRegistrationTime(regDate);
  }

  Future<void> deleteAccount() async {
    final profile = ref.read(profileNotifierProvider).value;
    final user = ref.read(authStateProvider).value;
    if (profile == null || user == null) {
      throw Exception('現在アカウント情報が取得できないためアカウントを削除できません。のちほどお試しください。');
    }

    await ref.read(accountDeleteUsecaseProvider).execute(user, profile);
  }
}

final accountNotifierProvider = NotifierProvider<AccountNotifier, AccountInfo>(
  () => AccountNotifier(),
);
