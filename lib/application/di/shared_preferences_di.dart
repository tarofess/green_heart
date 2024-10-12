import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/string_save_shared_preferences_usecase.dart';
import 'package:green_heart/application/usecase/string_get_shared_preferences_usecase.dart';
import 'package:green_heart/infrastructure/service/string_shared_preferences_service.dart';

final stringSaveSharedPreferencesUsecaseProvider =
    Provider<StringSaveSharedPreferencesUsecase>(
  (ref) => StringSaveSharedPreferencesUsecase(StringSharedPreferencesService()),
);

final stringGetSharedPreferencesUsecaseProvider =
    Provider<StringGetSharedPreferencesUsecase>(
  (ref) => StringGetSharedPreferencesUsecase(StringSharedPreferencesService()),
);
