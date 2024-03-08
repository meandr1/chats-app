import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  Future<User?> signInWithCredential(
      {required AuthCredential credential}) async {
    try {
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
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
          verificationFailed: (FirebaseAuthException e) {
            onError();
          },
          codeSent: onCodeSent,
          codeAutoRetrievalTimeout: (String verificationId) {},
        )
        .onError((error, stackTrace) => onError);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final userCredential =
          await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }
}
