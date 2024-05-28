import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController {
  // Método asincrónico para obtener el rol del usuario logueado.
  Future<int?> getUserRole(String email) async {
    try {
      // Acceder a Firestore y buscar el documento del usuario utilizando su correo electrónico
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      // Verificar si el documento existe y contiene el campo 'role'
      if (userDoc.exists && userDoc.data()!.containsKey('role')) {
        // Obtener el valor del campo 'role' del documento
        final userRole = userDoc.get('role');
        return userRole;
      } else {
        // Si el documento no existe o no contiene el campo 'role'
        return null;
      }
    } catch (e) {
      // Manejar errores
      print('Error al obtener el rol del usuario: $e');
      return null;
    }
  }

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

      final user = userCredential.user;

      if (user != null) {
        // Obtener el rol del usuario logueado
        final userRole = await getUserRole(user.email!);

        if (userRole != null) {
          // Devolver el rol junto con el mensaje de bienvenida
          return {
            'success': true,
            'message': '¡Bienvenido, ${user.displayName}!',
            'userRole': userRole,
          };
        } else {
          // Si no se puede obtener el rol del usuario
          return {
            'success': false,
            'message': 'No se pudo obtener el rol del usuario.',
          };
        }
      } else {
        // Si no se puede obtener el usuario
        return {
          'success': false,
          'message': 'No se pudo obtener el usuario.',
        };
      }
    } catch (e) {
      // Capturar errores
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
