import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_setting.freezed.dart';
part 'notification_setting.g.dart';

@freezed
class NotificationSetting with _$NotificationSetting {
  const factory NotificationSetting({
    required String uid,
    required String token,
    required String deviceId,
    @Default(true) bool likeSetting,
    @Default(true) bool commentSetting,
    @Default(true) bool followerSetting,
    required DateTime updatedAt,
  }) = _NotificationSetting;

  factory NotificationSetting.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingFromJson(json);
}
