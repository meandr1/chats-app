mixin Validator {
  String? passValidator(String? password) {
  return password == null || password.isEmpty
        ? 'Please enter password'
        : password.length < 6
            ? 'Password is too short'
            : null;
  }

  String? emailValidator(String? email) {
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.([a-zA-Z]{2,})+",
    );
    return email == null || email.isEmpty
        ? 'Please enter email'
        : emailRegex.hasMatch(email)
            ? null
            : 'Invalid email address';
  }
}
