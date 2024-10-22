import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/application/usecase/profile_save_usecase.dart';
import 'package:green_heart/application/usecase/string_save_shared_pref_usecase.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/application/di/shared_pref_di.dart';

class ProfileEditPageViewModel {
  final ProfileSaveUsecase _profileSaveUsecase;
  final StringSaveSharedPrefUsecase _stringSaveSharedPrefUsecase;
  final ProfileNotifier _profileNotifier;
  final User? _user;

  ProfileEditPageViewModel(
    this._profileSaveUsecase,
    this._stringSaveSharedPrefUsecase,
    this._profileNotifier,
    this._user,
  );

  Future<void> saveProfile(
    String name,
    String birthday,
    String bio, {
    required String imagePath,
    required String? oldImageUrl,
  }) async {
    if (_user == null) {
      throw Exception('プロフィールが保存できません。アカウントがログアウトされている可能性があります。');
    }

    final savedProfile = await _profileSaveUsecase.execute(
      _user.uid,
      name,
      birthday,
      bio,
      imagePath,
      oldImageUrl,
    );

    await _stringSaveSharedPrefUsecase.execute('uid', _user.uid);
    _profileNotifier.setProfile(savedProfile);
  }
}

final profileEditPageViewModelProvider = Provider(
  (ref) => ProfileEditPageViewModel(
    ref.read(profileSaveUsecaseProvider),
    ref.read(stringSaveSharedPrefUsecaseProvider),
    ref.read(profileNotifierProvider.notifier),
    ref.watch(authStateProvider).value,
  ),
);
