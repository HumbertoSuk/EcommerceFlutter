import 'package:firebase_auth/firebase_auth.dart';

//Modelo de representacion del usuario
class UserModel {
  final String uid;
  final String email;
  final bool emailVerified;

  UserModel({
    required this.uid,
    required this.email,
    required this.emailVerified,
  });

  // Factory method para crear un UserModel a partir de un User de Firebase.
  //  un constructor que no siempre crea una nueva instancia de la clase en
  // la que se encuentra. En cambio, puede devolver una instancia existente

  factory UserModel.fromFirebaseUser(User user) {
    // Retorna un nuevo UserModel con los datos del User de Firebase.
    return UserModel(
      uid: user.uid,
      email: user.email ?? '', // puede ser nulo si no está disponible
      emailVerified: user.emailVerified,
    );
  }
}
