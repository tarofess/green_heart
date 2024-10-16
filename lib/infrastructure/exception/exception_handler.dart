import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:green_heart/application/exception/app_exception.dart';

class ExceptionHandler {
  static AppException? handleException(dynamic e) {
    if (e is FirebaseAuthException) {
      return _handleFirebaseAuthException(e);
    } else if (e is SignInWithAppleAuthorizationException) {
      return _handleAppleAuthException(e);
    } else if (e is FirebaseException) {
      return AppException('Firebaseエラー: ${e.message}', e);
    } else if (e is TimeoutException) {
      return AppException('接続がタイムアウトしました。インターネット復帰後にデータが自動で同期されます。', e);
    } else if (e is SocketException) {
      return AppException('ネットワーク接続エラーが発生しました。インターネット復帰後にデータが自動で同期されます。', e);
    } else if (e is HttpException) {
      return AppException('HTTPエラーが発生しました。インターネット復帰後にデータが自動で同期されます。', e);
    } else if (e is FormatException) {
      return AppException('データフォーマットが不正です。正しいデータを入力してください。', e);
    } else if (e is Exception) {
      return null;
    } else {
      return AppException('予期せぬエラーが発生しました。しばらくしてから再度お試しください。', e);
    }
  }

  static AppException _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return AppException('このアカウントは既に別の方法で登録されています。別の方法でログインしてください。', e);
      case 'invalid-credential':
        return AppException('認証情報が無効です。再度お試しください。', e);
      case 'user-disabled':
        return AppException('このアカウントは無効化されています。サポートにお問い合わせください。', e);
      case 'user-not-found':
        return AppException('アカウントが見つかりません。新規登録をお試しください。', e);
      case 'operation-not-allowed':
        return AppException('この認証方法は現在利用できません。', e);
      case 'network-request-failed':
        return AppException('ネットワークエラーが発生しました。インターネット接続を確認してください。', e);
      default:
        return AppException('Firebaseエラー: ${e.message}', e);
    }
  }

  static AppException _handleAppleAuthException(
      SignInWithAppleAuthorizationException e) {
    switch (e.code) {
      case AuthorizationErrorCode.canceled:
        return AppException('Appleログインがキャンセルされました。', e);
      case AuthorizationErrorCode.failed:
        return AppException('Appleログインに失敗しました。再度お試しいただくか、別の方法でログインしてください。', e);
      case AuthorizationErrorCode.invalidResponse:
        return AppException('Appleからの応答に問題がありました。しばらくしてから再度お試しください。', e);
      case AuthorizationErrorCode.notHandled:
        return AppException('Appleログインの処理中に問題が発生しました。別の方法でログインしてください。', e);
      case AuthorizationErrorCode.unknown:
        return AppException('予期せぬエラーが発生しました。しばらくしてから再度お試しください。', e);
      default:
        return AppException('Appleログインに失敗しました。別の方法でログインしてください。', e);
    }
  }
}
