import 'package:green_heart/application/interface/auth_service.dart';

class AppleSignInUseCase {
  final AuthService _authService;

  AppleSignInUseCase(this._authService);

  Future<void> execute() async {
    await _authService.signInWithApple();
  }
}
