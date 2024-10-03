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
          throw Exception('無効な認証情報です。');
        case 'user-disabled':
          throw Exception('このユーザーアカウントは無効化されています。');
        case 'operation-not-allowed':
          throw Exception('Appleサインインが有効になっていません。');
        default:
          throw Exception('認証に失敗しました: ${e.message}');
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      switch (e.code) {
        case AuthorizationErrorCode.canceled:
          throw Exception('Appleサインインがキャンセルされました。');
        case AuthorizationErrorCode.failed:
          throw Exception('Appleサインインに失敗しました。');
        case AuthorizationErrorCode.invalidResponse:
          throw Exception('Appleサインインのレスポンスが無効です。');
        case AuthorizationErrorCode.notHandled:
          throw Exception('Appleサインインが処理されていません。');
        case AuthorizationErrorCode.unknown:
          throw Exception('Appleサインインで不明なエラーが発生しました。');
        default:
          throw Exception('Appleサインインに失敗しました: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
