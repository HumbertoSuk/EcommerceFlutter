import 'package:app_lenses_commerce/models/userModel.dart';
import 'package:app_lenses_commerce/presentation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginController {
  // Método asincrónico para iniciar sesión con correo electrónico y contraseña.
  Future<void> signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    // Capturamos el BuildContext en una variable local
    final scaffoldContext = context;

    try {
      // Login
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Se crea un modelo de usuario a partir del usuario de Firebase
      final userModel = UserModel.fromFirebaseUser(userCredential.user!);

      // Verifica si el usuario está autenticado y su correo electrónico está verificado
      if (userModel.isAuthenticated() && userModel.isEmailVerified()) {
        // Se muestra un mensaje de bienvenida con el nombre del usuario
        SnackBarUtils.showCustomSnackBar(
          scaffoldContext,
          '¡Bienvenido, ${userModel.name ?? userModel.email}!',
          duration: const Duration(seconds: 5),
        );

        GoRouter.of(scaffoldContext).go('/Home');
      } else {
        // Si el usuario no está autenticado o su correo electrónico no está verificado,
        SnackBarUtils.showCustomSnackBar(
          scaffoldContext,
          'Por favor, verifica tu correo electrónico para iniciar sesión.',
          duration: const Duration(seconds: 3),
        );
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('credential is incorrect')) {
        // Si las credenciales son incorrectas, se muestra un mensaje de error
        SnackBarUtils.showCustomSnackBar(
          scaffoldContext,
          'Contraseña o usuario incorrectos.',
          duration: const Duration(seconds: 3),
        );
      } else if (errorMessage
          .contains('blocked all requests from this device')) {
        // Si las solicitudes están bloqueadas desde este dispositivo, se muestra un mensaje indicando que el dispositivo ha sido bloqueado
        SnackBarUtils.showCustomSnackBar(
          scaffoldContext,
          'El dispositivo fue bloqueado por actividad sospechosa, inténtelo más tarde o intente cambiar de contraseña',
          duration: const Duration(seconds: 3),
        );
      } else if (errorMessage.contains('email_not_verified')) {
        SnackBarUtils.showCustomSnackBar(
          scaffoldContext,
          'Por favor, verifica tu correo electrónico para iniciar sesión.',
          duration: const Duration(seconds: 3),
        );
      } else {
        SnackBarUtils.showCustomSnackBar(
          scaffoldContext,
          'Error al iniciar sesión: $e',
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      // Manejo de errores genéricos
      SnackBarUtils.showCustomSnackBar(
        scaffoldContext,
        'Error al iniciar sesión: $e',
        duration: const Duration(seconds: 3),
      );
    }
  }
}
