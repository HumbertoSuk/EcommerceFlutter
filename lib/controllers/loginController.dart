import 'package:app_lenses_commerce/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginController {
  Future<void> signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null && userCredential.user!.emailVerified) {
        final userModel = UserModel.fromFirebaseUser(userCredential.user!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Bienvenido, ${userModel.email}!'),
            duration: Duration(seconds: 3),
          ),
        );
        GoRouter.of(context).go('/Home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Por favor, verifica tu correo electrónico para iniciar sesión.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('credential is incorrect')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contraseña o usuario incorrectos.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (errorMessage
          .contains('blocked all requests from this device')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'El dispositivo fue bloqueado por actividad sospechosa, inténtelo más tarde o intente cambiar de contraseña'),
            duration: Duration(seconds: 3),
          ),
        );
      } else if (errorMessage.contains('email_not_verified')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Por favor, verifica tu correo electrónico para iniciar sesión.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar sesión: $e'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
