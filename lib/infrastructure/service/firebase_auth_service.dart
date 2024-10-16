import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:green_heart/application/interface/auth_service.dart';
import 'package:green_heart/infrastructure/util/auth_utils.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await _auth.signInWithCredential(credential);
      }
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
    } on TimeoutException catch (_) {
      throw Exception('接続がタイムアウトしました。ネットワーク状態を確認して再度お試しください。');
    } catch (e) {
      throw Exception('予期せぬエラーが発生しました。しばらくしてから再度お試しください。');
    }
  }

  @override
  Future<void> signInWithApple() async {
    try {
      final rawNonce = AuthUtils.generateNonce();
      final nonce = AuthUtils.sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      await _auth.signInWithCredential(oauthCredential);
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
    } on TimeoutException catch (_) {
      throw Exception('接続がタイムアウトしました。ネットワーク状態を確認して再度お試しください。');
    } catch (e) {
      throw Exception('予期せぬエラーが発生しました。しばらくしてから再度お試しください。');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
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
