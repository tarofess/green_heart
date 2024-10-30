import 'package:green_heart/application/interface/report_repository.dart';

class ReportAddUsecase {
  final ReportRepository _reportRepository;

  ReportAddUsecase(this._reportRepository);

  Future<void> execute(
    String reportedPostId,
    String reporterUid,
    String reason,
  ) async {
    await _reportRepository.addReport(reportedPostId, reporterUid, reason);
  }
}
