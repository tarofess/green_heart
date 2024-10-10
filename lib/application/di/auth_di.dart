import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:green_heart/application/usecase/apple_signin_usecase.dart';
import 'package:green_heart/application/usecase/google_signin_usecase.dart';
import 'package:green_heart/application/usecase/signout_usecase.dart';
import 'package:green_heart/application/interface/auth_repository.dart';
import 'package:green_heart/infrastructure/repository/firebase_auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(),
);

final googleSignInUseCaseProvider = Provider<GoogleSignInUseCase>(
  (ref) => GoogleSignInUseCase(FirebaseAuthRepository()),
);

final appleSignInUseCaseProvider = Provider<AppleSignInUseCase>(
  (ref) => AppleSignInUseCase(FirebaseAuthRepository()),
);

final signOutUseCaseProvider = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(FirebaseAuthRepository()),
);
