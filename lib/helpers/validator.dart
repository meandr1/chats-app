abstract class Validator {
  static String? passValidator(String? password) {
    return password == null || password.isEmpty
        ? 'Please enter password'
        : password.length < 6
            ? 'Password is too short'
            : null;
  }

  static String? emailValidator(String? email) {
    final RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.([a-zA-Z]{2,})+");
    return email == null || email.isEmpty
        ? 'Please enter email'
        : emailRegex.hasMatch(email)
            ? null
            : 'Invalid email address';
  }

  static String? phoneValidator(String? phone) {
    final RegExp phoneRegex = RegExp(r"^\d{9}$");
    return phone == null || phone.isEmpty
        ? 'Please enter phone number'
        : phoneRegex.hasMatch(phone)
            ? null
            : 'Invalid phone number';
  }

  static String? emptyFieldValidator(value) {
    return value == null || value.isEmpty ? 'This field can\'t be empty' : null;
  }

  static bool isSmsCodeValid(String? smsCode) {
    return RegExp(r"^\d{6}$").hasMatch(smsCode ?? '');
  }
}
