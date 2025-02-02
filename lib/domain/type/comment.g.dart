// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    _$CommentImpl(
      id: json['id'] as String,
      uid: json['uid'] as String,
      content: json['content'] as String,
      parentCommentId: json['parentCommentId'] as String?,
      userName: json['userName'] as String,
      userImage: json['userImage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'content': instance.content,
      'parentCommentId': instance.parentCommentId,
      'userName': instance.userName,
      'userImage': instance.userImage,
      'createdAt': instance.createdAt.toIso8601String(),
    };
