// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LikeImpl _$$LikeImplFromJson(Map<String, dynamic> json) => _$LikeImpl(
      uid: json['uid'] as String,
      userName: json['userName'] as String,
      userImage: json['userImage'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$LikeImplToJson(_$LikeImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'userName': instance.userName,
      'userImage': instance.userImage,
      'createdAt': instance.createdAt.toIso8601String(),
    };
