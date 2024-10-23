// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentDataImpl _$$CommentDataImplFromJson(Map<String, dynamic> json) =>
    _$CommentDataImpl(
      comment: Comment.fromJson(json['comment'] as Map<String, dynamic>),
      userProfile: json['userProfile'] == null
          ? null
          : Profile.fromJson(json['userProfile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CommentDataImplToJson(_$CommentDataImpl instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'userProfile': instance.userProfile,
    };
