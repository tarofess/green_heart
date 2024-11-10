import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:green_heart/domain/type/profile.dart';

part 'user_page_state.freezed.dart';

@freezed
class UserPageState with _$UserPageState {
  const factory UserPageState({
    required Profile? profile,
    @Default(false) bool isFollowing,
    @Default(false) bool isBlocked,
  }) = _UserPageState;
}
