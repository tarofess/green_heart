import 'package:green_heart/application/interface/auth_service.dart';
import 'package:green_heart/domain/type/result.dart';

class GoogleSignInUseCase {
  final AuthService _authService;

  GoogleSignInUseCase(this._authService);

  Future<Result> execute() async {
    try {
      await _authService.signInWithGoogle();
      return const Success();
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
