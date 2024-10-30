abstract class ReportRepository {
  Future<void> addReport(
    String reportedPostId,
    String reporterUid,
    String reason,
  );
}
