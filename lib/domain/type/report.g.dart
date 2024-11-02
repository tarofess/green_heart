// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportImpl _$$ReportImplFromJson(Map<String, dynamic> json) => _$ReportImpl(
      reporterUid: json['reporterUid'] as String,
      reason: json['reason'] as String,
      reportedPostId: json['reportedPostId'] as String?,
      reportedCommentId: json['reportedCommentId'] as String?,
      reportedUserId: json['reportedUserId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: (json['status'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ReportImplToJson(_$ReportImpl instance) =>
    <String, dynamic>{
      'reporterUid': instance.reporterUid,
      'reason': instance.reason,
      'reportedPostId': instance.reportedPostId,
      'reportedCommentId': instance.reportedCommentId,
      'reportedUserId': instance.reportedUserId,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': instance.status,
    };
