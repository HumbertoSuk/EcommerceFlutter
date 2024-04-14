import 'package:email_validator/email_validator.dart';

mixin ValidationMixin {
  bool isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool isEmailValid(String email) {
    return EmailValidator.validate(email);
  }

  bool isPasswordValidRegister(String password) {
    // RegExpress para mejor contraseña
    return password.isNotEmpty &&
        password.length >= 8 &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[a-zA-Z]').hasMatch(password) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  bool isNameValid(String name) {
    // Validaciones para el username
    return name.isNotEmpty && !containsSpecialCharacters(name);
  }

  bool containsSpecialCharacters(String text) {
    final specialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return specialCharacters.hasMatch(text);
  }
}
