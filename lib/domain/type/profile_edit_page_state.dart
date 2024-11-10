import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:green_heart/domain/type/profile.dart';

part 'profile_edit_page_state.freezed.dart';

@freezed
class ProfileEditPageState with _$ProfileEditPageState {
  const factory ProfileEditPageState({
    required Profile? profile,
    required String? imagePath,
    required bool isShowBirthday,
    @Default('') String savedBirthday,
  }) = _ProfileEditPageState;
}
