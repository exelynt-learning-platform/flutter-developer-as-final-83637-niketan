import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;

  User? get currentUser;

  Future<UserCredential> login({required String email, required String password});

  Future<UserCredential> register({required String name, required String email, required String password});

  Future<void> forgotPassword({required String email});

  Future<UserCredential?> signInWithGoogle();

  Future<void> logout();
}
