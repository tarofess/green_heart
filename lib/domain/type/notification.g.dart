// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationImpl _$$NotificationImplFromJson(Map<String, dynamic> json) =>
    _$NotificationImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool,
      postId: json['postId'] as String?,
      postContent: json['postContent'] as String?,
      receiverUid: json['receiverUid'] as String,
      senderUid: json['senderUid'] as String,
      senderUserName: json['senderUserName'] as String,
      senderUserImage: json['senderUserImage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$NotificationImplToJson(_$NotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'isRead': instance.isRead,
      'postId': instance.postId,
      'postContent': instance.postContent,
      'receiverUid': instance.receiverUid,
      'senderUid': instance.senderUid,
      'senderUserName': instance.senderUserName,
      'senderUserImage': instance.senderUserImage,
      'createdAt': instance.createdAt.toIso8601String(),
    };
