import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/application/interface/report_repository.dart';
import 'package:green_heart/domain/type/report.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';

class FirebaseReportRepository implements ReportRepository {
  final int _timeoutSeconds = 15;

  @override
  Future<void> addReport(Report report) async {
    try {
      await FirebaseFirestore.instance
          .collection('report')
          .add(report.toJson())
          .timeout(Duration(seconds: _timeoutSeconds));
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('報告に失敗しました。再度お試しください。');
    }
  }
}
