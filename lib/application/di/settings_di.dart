import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/app_info_usecase.dart';
import 'package:green_heart/infrastructure/repository/my_app_info_repository.dart';
import 'package:green_heart/application/usecase/update_history_usecase.dart';
import 'package:green_heart/infrastructure/repository/update_history_file_repository.dart';

final appInfoUsecaseProvider = Provider(
  (ref) => AppInfoUsecase(MyAppInfoRepository()),
);

final updateHistoryUsecaseProvider = Provider(
  (ref) => UpdateHistoryUsecase(UpdateHistoryFileRepository()),
);
