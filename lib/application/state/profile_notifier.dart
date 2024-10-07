import 'package:green_heart/application/state/profile_provider.dart';
import 'package:green_heart/application/state/shared_preferences_provider.dart';
import 'package:green_heart/domain/type/profile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileNotifier extends AsyncNotifier<Profile?> {
  @override
  Future<Profile?> build() async {
    final uid = await ref.read(sharedPreferencesServiceProvider).getUid();
    if (uid == null) {
      return null;
    }

    final profile = await ref.read(profileGetProvider).execute(uid);
    return profile;
  }

  Future<void> setProfile(Profile profile) async {
    state = AsyncData(profile);
  }
}
