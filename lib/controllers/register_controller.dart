import 'package:app_lenses_commerce/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController {
  // Método para registrar un nuevo usuario
  //Devuelve un MAP de strings y es dinamico, puede proporcionar flexibilidad en el tipo de dato(int,double, etc)

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  })

  //Asynchronously
  async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

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

      // Devuelve un mapa con los resultados del registro
      return {
        'success': true,
        'email': userModel.userEmail,
        'errorMessage': null,
      };
    } catch (e) {
      // En caso de error, devuelve un mapa con el indicador de error y el mensaje de error
      return {
        'success': false,
        'errorMessage': e.toString(),
      };
    }
  }
}
