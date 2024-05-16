import 'package:app_lenses_commerce/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  // Método asincrónico para iniciar sesión con correo electrónico y contraseña.
  Future<Map<String, dynamic>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Crear un objeto UserModel a partir del usuario de Firebase
      final userModel = UserModel.fromFirebaseUser(userCredential.user!);

      // Verificar si el usuario está autenticado y si su correo electrónico está verificado
      if (userModel.isAuthenticated() && userModel.isEmailVerified()) {
        //  devolver un mensaje de bienvenida
        return {
          'success': true,
          'message': '¡Bienvenido, ${userModel.name}!',
        };
      } else {
        // Si el usuario no está autenticado o su correo electrónico no está verificado
        return {
          'success': false,
          'message':
              'Por favor, verifica tu correo electrónico para iniciar sesión.',
        };
      }
    } on FirebaseAuthException catch (e) {
      // Capturar errores específicos de FirebaseAuth
      final errorMessage = e.toString();
      if (errorMessage.contains('credential is incorrect')) {
        return {
          'success': false,
          'message': 'Contraseña o usuario incorrectos.',
        };
      } else if (errorMessage
          .contains('blocked all requests from this device')) {
        return {
          'success': false,
          'message':
              'El dispositivo fue bloqueado por actividad sospechosa, inténtelo más tarde o intente cambiar de contraseña',
        };
      } else if (errorMessage.contains('email_not_verified')) {
        return {
          'success': false,
          'message':
              'Por favor, verifica tu correo electrónico para iniciar sesión.',
        };
      } else {
        // Capturar otros errores de FirebaseAuth
        return {
          'success': false,
          'message': 'Error al iniciar sesión: $e',
        };
      }
    } catch (e) {
      // Capturar otros errores
      return {
        'success': false,
        'message': 'Error al iniciar sesión: $e',
      };
    }
  }

  // Método para cerrar sesión
  Future<Map<String, dynamic>> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Éxito al cerrar sesión
      return {'success': true, 'message': 'Cierre de sesión exitoso'};
    } catch (e) {
      // Error al cerrar sesión
      print('Error al cerrar sesión: $e');
      return {'success': false, 'message': 'Error al cerrar sesión: $e'};
    }
  }
}
