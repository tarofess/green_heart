import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signOut();
}
