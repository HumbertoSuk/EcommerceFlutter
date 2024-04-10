import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ValueNotifier<bool> isFilled = ValueNotifier<bool>(false);
  bool isPasswordVisible = false;
  bool isEmailValid = true;

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isFilled.dispose();
  }

  void checkFields() {
    final isEmailValid = EmailValidator.validate(emailController.text);
    final isPasswordValid = _isPasswordValid(passwordController.text);

    isEmailValid ? isEmailValid = true : isEmailValid = false;

    isFilled.value = isEmailValid && isPasswordValid;
  }

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
  }

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Verifica si el correo electrónico del usuario está verificado
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        // Si el inicio de sesión es exitoso y el correo electrónico está verificado,
        GoRouter.of(context).go('/Home');
      } else {
        // Si el correo electrónico no está verificado, muestra un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Por favor, verifica tu correo electrónico para iniciar sesión.'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      // Error durante el inicio de sesión
      final errorMessage = e.toString();
      if (errorMessage.contains('credential is incorrect')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Contraseña o usuario incorrectos.'),
          duration: Duration(seconds: 3),
        ));
      } else if (errorMessage
          .contains('blocked all requests from this device')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'EL dispositivo fue bloquedado por actividad sospechosa, intente mas tarde o intente cambiar de contraseña'),
          duration: Duration(seconds: 3),
        ));
      } else {
        // Otro tipo de error, muestra un mensaje de error general
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al iniciar sesión: $e'),
          duration: Duration(seconds: 3),
        ));
      }
    }
  }
}
