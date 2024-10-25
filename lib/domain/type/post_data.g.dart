// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostDataImpl _$$PostDataImplFromJson(Map<String, dynamic> json) =>
    _$PostDataImpl(
      post: Post.fromJson(json['post'] as Map<String, dynamic>),
      userProfile: json['userProfile'] == null
          ? null
          : Profile.fromJson(json['userProfile'] as Map<String, dynamic>),
      likes: (json['likes'] as List<dynamic>)
          .map((e) => Like.fromJson(e as Map<String, dynamic>))
          .toList(),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CommentData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PostDataImplToJson(_$PostDataImpl instance) =>
    <String, dynamic>{
      'post': instance.post,
      'userProfile': instance.userProfile,
      'likes': instance.likes,
      'comments': instance.comments,
    };
