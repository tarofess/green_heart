import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_heart/application/interface/auth_repository.dart';

class GoogleSignInUseCase {
  final AuthRepository _authRepository;

  GoogleSignInUseCase(this._authRepository);

  Future<User?> execute() async {
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user == null) {
        throw Exception('Googleサインインがキャンセルされました。');
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw Exception('アカウントは既に別の認証情報で存在します。');
      } else if (e.code == 'invalid-credential') {
        throw Exception('無効な認証情報です。');
      }
      throw Exception('認証に失敗しました: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}
