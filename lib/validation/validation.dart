import 'package:email_validator/email_validator.dart';

class Validations {
  static bool isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  static bool isEmailValid(String email) {
    return EmailValidator.validate(email);
  }
}
