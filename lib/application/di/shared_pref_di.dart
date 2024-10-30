import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/shared_pref_save_usecase.dart';
import 'package:green_heart/application/usecase/shared_pref_get_usecase.dart';
import 'package:green_heart/infrastructure/service/generic_shared_pref_service.dart';
import 'package:green_heart/application/usecase/shared_pref_delete_usecase.dart';

final sharedPrefSaveUsecaseProvider = Provider<SharedPrefSaveUsecase>(
  (ref) => SharedPrefSaveUsecase(GenericSharedPrefService()),
);

final sharedPrefGetUsecaseProvider = Provider<SharedPrefGetUsecase>(
  (ref) => SharedPrefGetUsecase(GenericSharedPrefService()),
);

final sharedPrefDeleteUsecaseProvider = Provider<SharedPrefDeleteUsecase>(
  (ref) => SharedPrefDeleteUsecase(GenericSharedPrefService()),
);
