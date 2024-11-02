// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlockDataImpl _$$BlockDataImplFromJson(Map<String, dynamic> json) =>
    _$BlockDataImpl(
      block: Block.fromJson(json['block'] as Map<String, dynamic>),
      profile: json['profile'] == null
          ? null
          : Profile.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BlockDataImplToJson(_$BlockDataImpl instance) =>
    <String, dynamic>{
      'block': instance.block,
      'profile': instance.profile,
    };
