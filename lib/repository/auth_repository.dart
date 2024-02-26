import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      return null;
    }
  }

  Stream<User?> get user => _firebaseAuth.userChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
