import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/report_repository.dart';
import 'package:green_heart/domain/type/report.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseReportRepository implements ReportRepository {
  @override
  Future<void> addReport(
    String reporterUid,
    String reason, {
    required String? reportedPostId,
    required String? reportedCommentId,
    required String? reportedUserId,
  }) async {
    try {
      final report = Report(
        reporterUid: reporterUid,
        reason: reason,
        reportedPostId: reportedPostId,
        reportedCommentId: reportedCommentId,
        reportedUserId: reportedUserId,
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('report')
          .add(report.toJson());
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('報告に失敗しました。再度お試しください。');
    }
  }
}
