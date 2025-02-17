import 'package:freezed_annotation/freezed_annotation.dart';

part 'report.freezed.dart';
part 'report.g.dart';

@freezed
class Report with _$Report {
  const factory Report({
    required String reporterUid,
    required String reason,
    required String? reportedPostId,
    required String? reportedCommentId,
    required String? reportedUserId,
    required DateTime createdAt,
    @Default(0) int status,
  }) = _Report;

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}
