import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/app_version_get_usecase.dart';
import 'package:green_heart/infrastructure/service/my_app_info_service.dart';
import 'package:green_heart/application/usecase/email_send_usecase.dart';
import 'package:green_heart/infrastructure/service/contact_email_service.dart';
import 'package:green_heart/application/usecase/app_info_read_text_file_usecase.dart';
import 'package:green_heart/infrastructure/service/app_info_file_service.dart';

final appVersionGetUsecaseProvider = Provider(
  (ref) => AppVersionGetUsecase(MyAppInfoService()),
);

final emailSendUsecaseProvider = Provider(
  (ref) => EmailSendUsecase(ContactEmailService()),
);

final appInfoReadTextFileUsecaseProvider = Provider(
  (ref) => AppInfoReadTextFileUsecase(AppInfoFileService()),
);
