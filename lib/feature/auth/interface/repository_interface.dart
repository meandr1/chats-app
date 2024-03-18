import 'package:firebase_auth/firebase_auth.dart';

abstract class RepositoryInterface {
  Future<User?> signInWithCredential({required AuthCredential credential});

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<User?> register({
    required String email,
    required String password,
  });

  Future<String?> sendVerificationEmail();

  Future<String?> sendPasswordResetEmail(String email);

  Future<void> verifyPhoneNumber(
      {required String phone,
      required Function(String verificationId, int? resendToken) onCodeSent,
      required Function(String? error) onError});

  Future<OAuthCredential> getGoogleCredentials();

  Future<OAuthCredential> getFacebookCredentials();

  User? getCurrentUser();
}
