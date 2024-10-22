import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/di/shared_pref_di.dart';
import 'package:green_heart/application/di/profile_di.dart';
import 'package:green_heart/domain/type/profile.dart';

class ProfileNotifier extends AsyncNotifier<Profile?> {
  @override
  Future<Profile?> build() async {
    final uid =
        await ref.read(stringGetSharedPrefUsecaseProvider).execute('uid');
    if (uid == null) {
      return null;
    }

    final profile = await ref.read(profileGetUsecaseProvider).execute(uid);
    return profile;
  }

  void setProfile(Profile? profile) {
    state = AsyncData(profile);
  }
}

final profileNotifierProvider =
    AsyncNotifierProvider<ProfileNotifier, Profile?>(
  () => ProfileNotifier(),
);
