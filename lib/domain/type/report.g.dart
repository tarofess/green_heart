// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportImpl _$$ReportImplFromJson(Map<String, dynamic> json) => _$ReportImpl(
      reportedPostId: json['reportedPostId'] as String,
      reporterUid: json['reporterUid'] as String,
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: (json['status'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ReportImplToJson(_$ReportImpl instance) =>
    <String, dynamic>{
      'reportedPostId': instance.reportedPostId,
      'reporterUid': instance.reporterUid,
      'reason': instance.reason,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': instance.status,
    };
