import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/account_info.dart';
import 'package:green_heart/domain/util/date_util.dart';
import 'package:green_heart/application/di/auth_di.dart';
import 'package:green_heart/application/di/account_di.dart';
import 'package:green_heart/application/state/block_notifier.dart';
import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:green_heart/application/di/comment_di.dart';
import 'package:green_heart/application/di/like_di.dart';
import 'package:green_heart/application/state/account_state_notifier.dart';
import 'package:green_heart/application/di/follow_di.dart';
import 'package:green_heart/application/di/notification_di.dart';

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

    await ref.read(accountReauthUsecaseProvider).execute(user);

    final deleteTasks = Future.wait([
      ref.read(notificationDeleteUsecaseProvider).execute(user),
      ref.read(likeDeleteAllUsecaseProvider).execute(user),
      ref.read(commentDeleteAllUsecaseProvider).execute(user),
      ref.read(followDeleteAllUsecaseProvider).execute(user),
      ref.read(blockNotifierProvider.notifier).deleteAllBlocks(user),
      ref.read(profileNotifierProvider.notifier).deleteProfile(user, profile),
      ref.read(userPostNotifierProvider(user.uid).notifier).deleteAllPosts(
            user,
          ),
    ]);

    await deleteTasks;
    Future.microtask(() {
      ref
          .read(accountStateNotifierProvider.notifier)
          .setAccountDeletedState(true);
    });
    await ref.read(accountDeleteUsecaseProvider).execute(user);
  }
}

final accountNotifierProvider = NotifierProvider<AccountNotifier, AccountInfo>(
  () => AccountNotifier(),
);
