import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_heart/application/interface/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> execute() async {
    try {
      await _authRepository.signOut();
    } on TimeoutException {
      throw Exception('サインアウト処理がタイムアウトしました。通信環境をご確認ください。');
    } on SocketException {
      throw Exception('ネットワーク接続エラーが発生しました。インターネット接続をご確認ください。');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'network-request-failed':
          throw Exception('ネットワークエラーが発生しました。インターネット接続をご確認ください。');
        case 'user-not-found':
          throw Exception('ユーザーが見つかりません。既にサインアウトしている可能性があります。');
        case 'user-disabled':
          throw Exception('このアカウントは無効化されています。サポートにお問い合わせください。');
        default:
          throw Exception('サインアウト中にエラーが発生しました: ${e.message}');
      }
    } on FirebaseException catch (e) {
      throw Exception('Firebaseエラーが発生しました: ${e.message}');
    } catch (e) {
      throw Exception('予期せぬエラーが発生しました。サポートにお問い合わせください。');
    }
  }
}
