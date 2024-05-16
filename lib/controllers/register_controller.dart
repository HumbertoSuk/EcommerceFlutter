import 'package:app_lenses_commerce/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController {
  // Método para registrar un nuevo usuario
  //Devuelve un MAP de strings y es dinamico, puede proporcionar flexibilidad en el tipo de dato(int,double, etc)

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para registrar un nuevo usuario
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Crea un usuario con correo electrónico y contraseña
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Actualiza el nombre de usuario en Firebase Auth
      await userCredential.user!.updateDisplayName(name);

      // Envía un correo electrónico de verificación al usuario
      await userCredential.user!.sendEmailVerification();

      // Crear UserModel a partir del usuario de Firebase
      final userModel = UserModel.fromFirebaseUser(userCredential.user!);

      // Insertar datos del usuario en Firestore
      await addUserToFirestore(userModel, name); // Pasa el nombre aquí

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

// Método para insertar un nuevo usuario en Firestore
  Future<void> addUserToFirestore(UserModel user, String name) async {
    try {
      // Generar el nombre del documento combinando el correo electrónico y la fecha actual
      final String documentName = user.userEmail;

      // Crear el mapa de datos para el nuevo usuario
      final Map<String, dynamic> userData = {
        'uid': user.userId,
        'email': user.userEmail,
        'username': name, // Usar el nombre pasado como parámetro
        'role': 0, // El rol siempre será el número 0 que es el de user
      };

      // Obtener la referencia a la colección "users" y agregar un nuevo documento con el nombre generado
      await _firestore.collection('users').doc(documentName).set(userData);

      print('Usuario agregado a Firestore exitosamente.');
    } catch (e) {
      print('Error al agregar usuario a Firestore: $e');
      throw e;
    }
  }
}
