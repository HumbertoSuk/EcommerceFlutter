import 'package:app_lenses_commerce/presentation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordController {
  Future<void> resetPassword(BuildContext context, String email) async {
    final scaffoldContext = context;
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.sendPasswordResetEmail(email: email);
      SnackBarUtils.showCustomSnackBar(
        scaffoldContext,
        'Se ha enviado un correo para restablecer la contraseña',
        duration: const Duration(seconds: 3),
      );

      //Redirigir a la raiz
      GoRouter.of(scaffoldContext).go('/');
    } catch (e) {
      SnackBarUtils.showCustomSnackBar(
        scaffoldContext,
        'Error:  $e',
        duration: const Duration(seconds: 3),
      );
    }
  }
}
