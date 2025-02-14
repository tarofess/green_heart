import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/firebase_init_usecase.dart';
import 'package:green_heart/infrastructure/service/firebase_init_service.dart';

final firebaseInitUsecaseProvider = Provider(
  (ref) => FirebaseInitUsecase(FirebaseInitService()),
);
