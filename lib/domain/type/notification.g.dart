// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationImpl _$$NotificationImplFromJson(Map<String, dynamic> json) =>
    _$NotificationImpl(
      uid: json['uid'] as String,
      token: json['token'] as String,
      deviceId: json['deviceId'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NotificationImplToJson(_$NotificationImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'token': instance.token,
      'deviceId': instance.deviceId,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
