import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:green_heart/application/interface/auth_service.dart';

class AppleSignInUseCase {
  final AuthService _authService;

  AppleSignInUseCase(this._authService);

  Future<void> execute() async {
    try {
      await _authService.signInWithApple();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          throw Exception('認証情報に問題があります。再度お試しください。');
        case 'user-disabled':
          throw Exception('このアカウントは現在使用できません。サポートにお問い合わせください。');
        case 'operation-not-allowed':
          throw Exception('申し訳ありませんが、現在Appleログインをご利用いただけません。');
        default:
          throw Exception('ログインに失敗しました。しばらくしてから再度お試しください。');
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          return;
        case AuthorizationErrorCode.failed:
          throw Exception('Appleログインに失敗しました。再度お試しいただくか、別の方法でログインしてください。');
        case AuthorizationErrorCode.invalidResponse:
          throw Exception('Appleからの応答に問題がありました。しばらくしてから再度お試しください。');
        case AuthorizationErrorCode.notHandled:
          throw Exception('Appleログインの処理中に問題が発生しました。別の方法でログインしてください。');
        case AuthorizationErrorCode.unknown:
          throw Exception('予期せぬエラーが発生しました。しばらくしてから再度お試しください。');
        default:
          throw Exception('Appleログインに失敗しました。別の方法でログインしてください。');
      }
    } catch (e) {
      rethrow;
    }
  }
}
