import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/state/profile_notifier.dart';
import 'package:green_heart/domain/type/profile_edit_page_state.dart';

class ProfileEditPageStateNotifier extends AsyncNotifier<ProfileEditPageState> {
  @override
  Future<ProfileEditPageState> build() async {
    final profile = ref.watch(profileNotifierProvider).value;
    final isShowBirthday = profile?.birthday == null ? false : true;

    return ProfileEditPageState(
      profile: profile,
      isShowBirthday: isShowBirthday,
    );
  }

  void setIsShowBirthday(bool isShowBirthday) {
    state.whenData((currentState) {
      state = AsyncValue.data(
        currentState.copyWith(isShowBirthday: isShowBirthday),
      );
    });
  }

  void setSavedBirthday(String savedBirthday) {
    state.whenData((currentState) {
      state = AsyncValue.data(
        currentState.copyWith(savedBirthday: savedBirthday),
      );
    });
  }
}

final profileEditPageStateNotifierProvider =
    AsyncNotifierProvider<ProfileEditPageStateNotifier, ProfileEditPageState>(
  () => ProfileEditPageStateNotifier(),
);
