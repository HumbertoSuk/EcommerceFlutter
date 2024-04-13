import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordController {
  Future<void> resetPassword(BuildContext context, String email) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final successMessage =
        'Se ha enviado un correo para restablecer la contraseña';
    final errorMessage = 'Error al enviar el correo';

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSnackBar(context, successMessage);
      GoRouter.of(context).go('/');
    } catch (e) {
      _showSnackBar(context, '$errorMessage: $e');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
