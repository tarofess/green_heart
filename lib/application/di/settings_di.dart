import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/app_version_get_usecase.dart';
import 'package:green_heart/infrastructure/repository/my_app_info_repository.dart';
import 'package:green_heart/application/usecase/app_info_read_text_file_usecase.dart';
import 'package:green_heart/infrastructure/repository/app_info_file_repository.dart';

final appVersionGetUsecaseProvider = Provider(
  (ref) => AppVersionGetUsecase(MyAppInfoRepository()),
);

final appInfoReadTextFileUsecaseProvider = Provider(
  (ref) => AppInfoReadTextFileUsecase(AppInfoFileRepository()),
);
