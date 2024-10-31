import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/infrastructure/service/firebase_auth_service.dart';

class AccountReauthUsecase {
  final FirebaseAuthService _authService;

  AccountReauthUsecase(this._authService);

  Future<void> execute(User user) async {
    String? providerId = user.providerData
        .firstWhere((info) =>
            info.providerId == 'google.com' || info.providerId == 'apple.com')
        .providerId;

    if (providerId == 'google.com') {
      await _authService.reauthenticateWithGoogle();
    } else if (providerId == 'apple.com') {
      await _authService.reauthenticateWithApple();
    } else {
      throw AppException('サポートされていない認証プロバイダです。');
    }
  }
}
