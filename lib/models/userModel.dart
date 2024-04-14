import 'package:firebase_auth/firebase_auth.dart';

// Modelo de representación del usuario
class UserModel {
  final String uid;
  final String email;
  final bool emailVerified;
  String _name;

  UserModel({
    required this.uid,
    required this.email,
    required this.emailVerified,
    required String name, // Se agrega el nombre al constructor
  }) : _name = name; // Se inicializa el campo _name con el nombre proporcionado

  // Factory method para crear un UserModel a partir de un User de Firebase.
  // Un constructor que no siempre crea una nueva instancia de la clase en
  // la que se encuentra. En cambio, puede devolver una instancia existente
  factory UserModel.fromFirebaseUser(User user) {
    // Retorna un nuevo UserModel con los datos del User de Firebase.
    return UserModel(
      uid: user.uid,
      email: user.email ?? '', // Puede ser nulo si no está disponible
      emailVerified: user.emailVerified,
      name: user.displayName ??
          '', // Se utiliza el nombre del usuario si está disponible
    );
  }

  // Método para verificar si el usuario está autenticado
  bool isAuthenticated() {
    return uid.isNotEmpty;
  }

  // Método para verificar si el correo electrónico del usuario está verificado
  bool isEmailVerified() {
    return emailVerified;
  }

  // Getter para obtener el nombre del usuario
  String get name => _name;

  // Setter para actualizar el nombre del usuario
  set name(String newName) {
    _name = newName;
  }

  // Getter para obtener el UID del usuario
  String get userId => uid;

  // Getter para obtener el email del usuario
  String get userEmail => email;

  // Getter para verificar si el email del usuario está verificado
  bool get isEmailVerifiedValue => emailVerified;
}
