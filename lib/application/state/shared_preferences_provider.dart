import 'package:green_heart/infrastructure/service/shared_preferences_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((ref) {
  return SharedPreferencesService();
});
