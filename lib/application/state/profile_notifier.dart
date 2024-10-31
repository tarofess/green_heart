import 'package:green_heart/application/state/user_post_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';
import 'package:green_heart/application/usecase/profile_save_usecase.dart';

class ProfileNotifier extends AsyncNotifier<Profile?> {
  @override
  Future<Profile?> build() async {
    final uid = ref.watch(authStateProvider).value?.uid;
    if (uid == null) {
      return null;
    }

    final profile = await ref.read(profileGetUsecaseProvider).execute(uid);
    return profile;
  }

  Future<void> saveProfile(
    ProfileSaveUsecase profileSaveUsecase,
    String name,
    String birthday,
    String bio, {
    required String? imagePath,
    required String? oldImageUrl,
  }) async {
    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) {
      throw Exception('プロフィールが保存できません。アカウントがログアウトされている可能性があります。');
    }

    final savedProfile = await profileSaveUsecase.execute(
      uid,
      name,
      birthday,
      bio,
      imagePath,
      oldImageUrl,
    );

    ref
        .read(userPostNotifierProvider(uid).notifier)
        .updateProfileImage(uid, savedProfile.imageUrl);

    state = AsyncData(savedProfile);
  }

  void deleteProfile() {
    state = const AsyncData(null);
  }
}

final profileNotifierProvider =
    AsyncNotifierProvider<ProfileNotifier, Profile?>(
  () => ProfileNotifier(),
);
