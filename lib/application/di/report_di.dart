import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/report_add_usecase.dart';
import 'package:green_heart/infrastructure/repository/firebase_report_repository.dart';

final reportAddUsecaseProvider = Provider(
  (ref) => ReportAddUsecase(FirebaseReportRepository()),
);
