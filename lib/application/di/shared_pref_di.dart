import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/string_save_shared_pref_usecase.dart';
import 'package:green_heart/application/usecase/string_get_shared_pref_usecase.dart';
import 'package:green_heart/infrastructure/service/generic_shared_pref_service.dart';

final stringSaveSharedPrefUsecaseProvider =
    Provider<StringSaveSharedPrefUsecase>(
  (ref) => StringSaveSharedPrefUsecase(GenericSharedPrefService()),
);

final stringGetSharedPrefUsecaseProvider = Provider<StringGetSharedPrefUsecase>(
  (ref) => StringGetSharedPrefUsecase(GenericSharedPrefService()),
);
