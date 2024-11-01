// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlockImpl _$$BlockImplFromJson(Map<String, dynamic> json) => _$BlockImpl(
      uid: json['uid'] as String,
      blockedUid: json['blockedUid'] as String,
      blockedAt: DateTime.parse(json['blockedAt'] as String),
    );

Map<String, dynamic> _$$BlockImplToJson(_$BlockImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'blockedUid': instance.blockedUid,
      'blockedAt': instance.blockedAt.toIso8601String(),
    };
