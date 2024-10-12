import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_heart/application/interface/auth_service.dart';

class GoogleSignInUseCase {
  final AuthService _authService;

  GoogleSignInUseCase(this._authService);

  Future<void> execute() async {
    try {
      await _authService.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception('このアカウントは既に別の方法で登録されています。別の方法でログインしてください。');
        case 'invalid-credential':
          throw Exception('認証情報が無効です。再度お試しください。');
        case 'user-disabled':
          throw Exception('このアカウントは無効化されています。サポートにお問い合わせください。');
        case 'user-not-found':
          throw Exception('アカウントが見つかりません。新規登録をお試しください。');
        case 'operation-not-allowed':
          throw Exception('この認証方法は現在利用できません。');
        case 'network-request-failed':
          throw Exception('ネットワークエラーが発生しました。インターネット接続を確認してください。');
        default:
          throw Exception('認証中にエラーが発生しました: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
