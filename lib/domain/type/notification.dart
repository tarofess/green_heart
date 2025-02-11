import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
class Notification with _$Notification {
  const factory Notification({
    required String uid,
    required String token,
    required String deviceId,
    required DateTime updatedAt,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}
