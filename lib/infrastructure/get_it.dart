import 'package:get_it/get_it.dart';
import 'package:green_heart/presentation/service/navigation_service.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton(() => NavigationService());
}
