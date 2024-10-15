import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/profile_notifier_provider.dart';
import 'package:green_heart/application/usecase/profile_save_usecase.dart';
import 'package:green_heart/domain/type/profile.dart';

class AccountPageViewModel {
  final Profile? _profile;
  final User? _user;
  final ProfileSaveUsecase _profileSaveUsecase;

  AccountPageViewModel(
    this._profile,
    this._user,
    this._profileSaveUsecase,
  );

  Future<void> deleteAccount() async {
    final deletedProfile = _profile?.copyWith(
      status: -1,
      updatedAt: DateTime.now(),
    );

    if (deletedProfile == null && _user?.uid == null) {
      throw Exception('プロフィール情報が取得できませんでした。');
    }
    await _profileSaveUsecase.execute(
      _user!.uid,
      deletedProfile!,
      deletedProfile.imageUrl,
    );
  }
}

final accountPageViewModelProvider = Provider((ref) => AccountPageViewModel(
      ref.read(profileNotifierProvider).value,
      ref.read(authStateProvider).value,
      ref.read(profileSaveUsecaseProvider),
    ));
