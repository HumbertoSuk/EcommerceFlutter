import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController {
  Future<Map<String, dynamic>> resetPassword(String email) async {
    // Obtener una instancia de FirebaseAuth
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      // Enviar un correo electrónico para restablecer la contraseña
      await auth.sendPasswordResetEmail(email: email);

      // Si se envía el correo exitosamente, devolver la estructura de datos indicando éxito y un mensaje
      return {
        'success': true,
        'message': 'Se ha enviado un correo para restablecer la contraseña',
      };
    } catch (e) {
      // Si ocurre algún error durante el proceso, devolver un  la estructura de datos indicando falla y un mensaje de error
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}
