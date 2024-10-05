import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_heart/application/interface/auth_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInUseCase {
  final AuthRepository _authRepository;

  AppleSignInUseCase(this._authRepository);

  Future<User?> execute() async {
    try {
      final user = await _authRepository.signInWithApple();
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          throw Exception('認証情報に問題があります。再度お試しください。');
        case 'user-disabled':
          throw Exception('このアカウントは現在使用できません。サポートにお問い合わせください。');
        case 'operation-not-allowed':
          throw Exception('申し訳ありませんが、現在Appleサインインをご利用いただけません。');
        default:
          throw Exception('サインインに失敗しました。しばらくしてから再度お試しください。');
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          throw Exception('Appleサインインがキャンセルされました。再度お試しください。');
        case AuthorizationErrorCode.failed:
          throw Exception('Appleサインインに失敗しました。再度お試しいただくか、別の方法でサインインしてください。');
        case AuthorizationErrorCode.invalidResponse:
          throw Exception('Appleからの応答に問題がありました。しばらくしてから再度お試しください。');
        case AuthorizationErrorCode.notHandled:
          throw Exception('Appleサインインの処理中に問題が発生しました。別の方法でサインインしてください。');
        case AuthorizationErrorCode.unknown:
          throw Exception('予期せぬエラーが発生しました。しばらくしてから再度お試しください。');
        default:
          throw Exception('Appleサインインに失敗しました。別の方法でサインインしてください。');
      }
    } catch (e) {
      rethrow;
    }
  }
}
