import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';

@freezed
class Account with _$Account {
  const factory Account({
    required String providerName,
    required String email,
    required String registrationDate,
    @Default(true) bool isActive,
  }) = _Account;
}
