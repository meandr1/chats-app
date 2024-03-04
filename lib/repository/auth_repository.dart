import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  Future<User?> signInWithCredential(
      {required AuthCredential credential}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> signIn({
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

  Future<User?> register({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<String> sendVerificationEmail() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<void> verifyPhoneNumber(
      {required String phone,
      required Function(String verificationId, int? resendToken) onCodeSent,
      required Function onError}) async {
    await _firebaseAuth
        .verifyPhoneNumber(
          phoneNumber: '+380$phone',
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) { onError(e.message);},
          codeSent: onCodeSent,
          codeAutoRetrievalTimeout: (String verificationId) {},
        )
        .onError((error, stackTrace) => onError);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
