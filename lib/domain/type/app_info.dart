import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_info.freezed.dart';

@freezed
class AppInfo with _$AppInfo {
  const factory AppInfo({
    required String developerName,
    required String appVersion,
    required String termsOfUse,
    required String privacyPolicy,
    required String updateHistory,
  }) = _AppInfo;
}
