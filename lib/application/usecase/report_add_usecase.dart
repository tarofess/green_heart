import 'package:green_heart/application/interface/report_repository.dart';

class ReportAddUsecase {
  final ReportRepository _reportRepository;

  ReportAddUsecase(this._reportRepository);

  Future<void> execute(
    String reporterUid,
    String reason, {
    required String? reportedPostId,
    required String? reportedCommentId,
    required String? reportedUserId,
  }) async {
    await _reportRepository.addReport(
      reporterUid,
      reason,
      reportedPostId: reportedPostId,
      reportedCommentId: reportedCommentId,
      reportedUserId: reportedUserId,
    );
  }
}
