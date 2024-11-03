import 'package:green_heart/domain/type/report.dart';

abstract class ReportRepository {
  Future<void> addReport(Report report);
}
