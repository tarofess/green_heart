import 'package:green_heart/application/interface/auth_service.dart';
import 'package:green_heart/domain/type/result.dart';

class AppleSignInUseCase {
  final AuthService _authService;

  AppleSignInUseCase(this._authService);

  Future<Result> execute() async {
    try {
      await _authService.signInWithApple();
      return const Success(null);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
