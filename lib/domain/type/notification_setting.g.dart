// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationSettingImpl _$$NotificationSettingImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationSettingImpl(
      uid: json['uid'] as String,
      token: json['token'] as String,
      deviceId: json['deviceId'] as String,
      likeSetting: json['likeSetting'] as bool? ?? true,
      commentSetting: json['commentSetting'] as bool? ?? true,
      followerSetting: json['followerSetting'] as bool? ?? true,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NotificationSettingImplToJson(
        _$NotificationSettingImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'token': instance.token,
      'deviceId': instance.deviceId,
      'likeSetting': instance.likeSetting,
      'commentSetting': instance.commentSetting,
      'followerSetting': instance.followerSetting,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
