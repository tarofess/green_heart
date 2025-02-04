// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: json['id'] as String,
      uid: json['uid'] as String,
      content: json['content'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      userName: json['userName'] as String,
      userImage: json['userImage'] as String?,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'userName': instance.userName,
      'userImage': instance.userImage,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'releaseDate': instance.releaseDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
