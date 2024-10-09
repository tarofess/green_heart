import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/infrastructure/service/shared_preferences_service.dart';

final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>(
  (ref) => SharedPreferencesService(),
);
