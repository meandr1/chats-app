abstract class AuthInterface {
  bool get isEmailValid;

  bool get isPhoneValid;

  bool get isSignFormsValid;

  bool get isRegisterFormsValid;

  void emailChanged(String? value);

  void passwordChanged(String? value);

  void phoneChanged(String? value);

  void repeatPasswordChanged(String? value);

  void changeObscurePasswordStatus(bool value);

  Future<void> sendSMS();

  Future<void> loginWithSMSCode({required String smsCode});

  Future<void> sendVerificationEmail({required bool isResend});

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> loginWithPasswordAndEmail();

  Future<void> registerWithEmailAndPassword();

  Future<void> signInWithGoogle();

  Future<void> signInWithFacebook();
}
