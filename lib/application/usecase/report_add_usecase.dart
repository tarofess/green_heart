import 'package:green_heart/application/interface/report_repository.dart';
import 'package:green_heart/domain/type/report.dart';
import 'package:green_heart/domain/type/result.dart';

class ReportAddUsecase {
  final ReportRepository _reportRepository;

  ReportAddUsecase(this._reportRepository);

  Future<Result> execute(
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

      await _reportRepository.addReport(report);
      return const Success(null);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
