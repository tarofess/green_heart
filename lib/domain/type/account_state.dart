import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_state.freezed.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState({
    @Default(false) bool isRegistered,
    @Default(false) bool isDeleted,
  }) = _AccountState;
}
