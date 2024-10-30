import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_info.freezed.dart';

@freezed
class AccountInfo with _$AccountInfo {
  const factory AccountInfo({
    required String providerName,
    required String email,
    required String registrationDate,
  }) = _AccountInfo;
}
