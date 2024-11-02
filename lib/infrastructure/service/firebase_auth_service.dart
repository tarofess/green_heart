import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:green_heart/application/interface/auth_service.dart';
import 'package:green_heart/infrastructure/util/auth_utils.dart';
import 'package:green_heart/application/exception/app_exception.dart';
import 'package:green_heart/infrastructure/exception/exception_handler.dart';
import 'package:green_heart/application/exception/google_signin_cancel_exception.dart';

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

      if (googleSignInAccount == null) {
        throw GoogleSigninCancelException('Googleログインがキャンセルされました。');
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e, stackTrace) {
      if (e is GoogleSigninCancelException) {
        rethrow;
      }
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('ログインに失敗しました。再度お試しください。');
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
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('ログインに失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('ログアウトに失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> reauthenticateWithGoogle() async {
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

        await FirebaseAuth.instance.currentUser
            ?.reauthenticateWithCredential(credential);
      } else {
        throw AppException('Google認証に失敗しました。再度お試しください。');
      }
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('再認証に失敗しました。再度お試しください。');
    }
  }

  @override
  Future<void> reauthenticateWithApple() async {
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

      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(oauthCredential);
    } catch (e, stackTrace) {
      final exception = await ExceptionHandler.handleException(e, stackTrace);
      throw exception ?? AppException('再認証に失敗しました。再度お試しください。');
    }
  }
}
