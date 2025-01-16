import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:green_heart/application/state/auth_state_provider.dart';

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

  void saveProfile(Profile profile) {
    state = AsyncData(profile);
  }

  Future<void> deleteProfile(User user, Profile profile) async {
    await ref.read(profileDeleteUsecaseProvider).execute(user, profile);
    state = const AsyncData(null);
  }
}

final profileNotifierProvider =
    AsyncNotifierProvider<ProfileNotifier, Profile?>(
  () => ProfileNotifier(),
);
