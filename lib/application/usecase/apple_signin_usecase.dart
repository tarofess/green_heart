import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_heart/application/interface/auth_repository.dart';

class AppleSignInUseCase {
  final AuthRepository _authRepository;

  AppleSignInUseCase(this._authRepository);

  Future<User?> execute() async {
    try {
      final user = await _authRepository.signInWithApple();
      if (user == null) {
        throw Exception('Appleサインインがキャンセルされました');
      }
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          throw Exception('無効な認証情報です');
        case 'user-disabled':
          throw Exception('このユーザーアカウントは無効化されています');
        case 'operation-not-allowed':
          throw Exception('Appleサインインが有効になっていません');
        default:
          throw Exception('認証に失敗しました: ${e.message}');
      }
    } catch (e) {
      throw Exception('予期せぬエラーが発生しました: $e');
    }
  }
}
