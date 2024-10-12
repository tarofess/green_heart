import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/string_save_shared_preferences_usecase.dart';
import 'package:green_heart/application/usecase/string_get_shared_preferences_usecase.dart';
import 'package:green_heart/infrastructure/repository/string_shared_preferences_repository.dart';

final stringSaveSharedPreferencesUsecaseProvider =
    Provider<StringSaveSharedPreferencesUsecase>(
  (ref) =>
      StringSaveSharedPreferencesUsecase(StringSharedPreferencesRepository()),
);

final stringGetSharedPreferencesUsecaseProvider =
    Provider<StringGetSharedPreferencesUsecase>(
  (ref) =>
      StringGetSharedPreferencesUsecase(StringSharedPreferencesRepository()),
);
