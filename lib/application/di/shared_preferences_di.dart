import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/uid_save_shared_preferences_usecase.dart';
import 'package:green_heart/application/usecase/uid_get_shared_preferences_usecase.dart';
import 'package:green_heart/infrastructure/repository/uid_shared_preferences_repository.dart';

final uidSaveSharedPreferencesUsecaseProvider =
    Provider<UidSaveSharedPreferencesUsecase>(
  (ref) => UidSaveSharedPreferencesUsecase(UidSharedPreferencesRepository()),
);

final uidGetSharedPreferencesUsecaseProvider =
    Provider<UidGetSharedPreferencesUsecase>(
  (ref) => UidGetSharedPreferencesUsecase(UidSharedPreferencesRepository()),
);
