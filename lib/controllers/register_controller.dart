import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lenses_commerce/presentation/widgets/ScaffoldMessengerCustom/ScaffoldMessCustom.dart';

class RegisterController {
  // Método para registrar un nuevo usuario
  Future<void> register({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final scaffoldContext = context;

    try {
      // Crea un usuario con correo electrónico y contraseña
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Actualiza el nombre de usuario del usuario
      await userCredential.user!.updateDisplayName(name);

      // Envía un correo electrónico de verificación al usuario
      await userCredential.user!.sendEmailVerification();

      // Crear UserModel a partir del usuario de Firebase
      final userModel = UserModel.fromFirebaseUser(userCredential.user!);

      // Muestra un mensaje de éxito y redirige al usuario a la página de inicio
      SnackBarUtils.showCustomSnackBar(
        scaffoldContext,
        'Registro exitoso. Se ha enviado un correo de verificación.',
        duration: const Duration(seconds: 5),
      );
      GoRouter.of(context).go('/'); // Redirige al usuario a la página de inicio
    } catch (e) {
      // Muestra un mensaje de error en caso de fallo durante el registro
      SnackBarUtils.showCustomSnackBar(
        scaffoldContext,
        'Error durante el registro: $e',
        duration: const Duration(seconds: 5),
      );
    }
  }
}
