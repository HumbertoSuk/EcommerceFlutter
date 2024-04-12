import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register(
    String name,
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.sendEmailVerification();

      // Registro exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Registro exitoso. Se ha enviado un correo de verificación.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Ir a la pantalla principal
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error durante el registro: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      print('Error during registration: $e');
    }
  }
}
