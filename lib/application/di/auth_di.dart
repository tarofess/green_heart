import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/apple_signin_usecase.dart';
import 'package:green_heart/application/usecase/google_signin_usecase.dart';
import 'package:green_heart/application/usecase/signout_usecase.dart';
import 'package:green_heart/application/interface/auth_service.dart';
import 'package:green_heart/infrastructure/service/firebase_auth_service.dart';

final authRepositoryProvider = Provider<AuthService>(
  (ref) => FirebaseAuthService(),
);

final googleSignInUseCaseProvider = Provider<GoogleSignInUseCase>(
  (ref) => GoogleSignInUseCase(FirebaseAuthService()),
);

final appleSignInUseCaseProvider = Provider<AppleSignInUseCase>(
  (ref) => AppleSignInUseCase(FirebaseAuthService()),
);

final signOutUseCaseProvider = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(FirebaseAuthService()),
);
