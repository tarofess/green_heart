import 'package:green_heart/application/interface/auth_service.dart';

class GoogleSignInUseCase {
  final AuthService _authService;

  GoogleSignInUseCase(this._authService);

  Future<void> execute() async {
    await _authService.signInWithGoogle();
  }
}
