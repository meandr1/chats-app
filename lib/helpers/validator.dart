mixin Validator {
  String? passValidator(String? pass) {
  return pass == null || pass.isEmpty
        ? 'Please enter password'
        : pass.length < 6
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
