abstract class ReportRepository {
  Future<void> addReport(
    String reporterUid,
    String reason, {
    required String? reportedPostId,
    required String? reportedCommentId,
    required String? reportedUserId,
  });
}
