// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentDataImpl _$$CommentDataImplFromJson(Map<String, dynamic> json) =>
    _$CommentDataImpl(
      comment: Comment.fromJson(json['comment'] as Map<String, dynamic>),
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
      replyComments: (json['replyComments'] as List<dynamic>?)
              ?.map((e) => CommentData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isMe: json['isMe'] as bool? ?? false,
    );

Map<String, dynamic> _$$CommentDataImplToJson(_$CommentDataImpl instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'profile': instance.profile,
      'replyComments': instance.replyComments,
      'isMe': instance.isMe,
    };
