import 'package:chats/feature/auth/interface/repository_interface.dart';
import 'package:chats/feature/home/repository/home_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository implements RepositoryInterface {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User?> signInWithCredential(
      {required AuthCredential credential, String? provider}) async {
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    await HomeRepository().addUserIfNotExists(provider: provider);
    return userCredential.user;
  }

  @override
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential.user;
  }

  @override
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

  @override
  Future<String?> sendVerificationEmail() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  @override
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  @override
  Future<void> verifyPhoneNumber(
      {required String phone,
      required Function(String verificationId, int? resendToken) onCodeSent,
      required Function(String? error) onError}) async {
    await _firebaseAuth
        .verifyPhoneNumber(
          phoneNumber: '+380$phone',
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            onError(e.message);
          },
          codeSent: onCodeSent,
          codeAutoRetrievalTimeout: (String verificationId) {},
        )
        .onError((error, stackTrace) => onError(null));
  }

  @override
  Future<OAuthCredential> getGoogleCredentials() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return googleAuthCredential;
  }

  @override
  Future<OAuthCredential> getFacebookCredentials() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return facebookAuthCredential;
  }

  @override
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
