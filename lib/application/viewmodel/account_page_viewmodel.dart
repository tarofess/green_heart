import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/profile_notifier_provider.dart';

class AccountPageViewModel {
  Future<void> deleteAccount(WidgetRef ref) async {
    final deletedProfile = ref.read(profileNotifierProvider).value?.copyWith(
          status: -1,
          updatedAt: DateTime.now(),
        );
    final uid = ref.read(authStateProvider).value?.uid;

    if (deletedProfile == null || uid == null) {
      throw Exception('プロフィール情報が取得できませんでした。');
    }
    await ref.read(profileSaveUsecaseProvider).execute(uid, deletedProfile);
  }
}

final accountPageViewModelProvider = Provider((ref) => AccountPageViewModel());
