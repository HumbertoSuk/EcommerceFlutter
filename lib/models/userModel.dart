import 'package:firebase_auth/firebase_auth.dart';

// Modelo de representación del usuario
class UserModel {
  final String _uid;
  late final bool _emailVerified;
  late final String _name;
  late final String _email;

  UserModel({
    required String uid,
    required bool emailVerified,
    required String name,
    required String email,
  })  : _uid = uid,
        _emailVerified = emailVerified,
        _name = name,
        _email = email;

  // Factory method para crear un UserModel a partir de un User de Firebase.
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      emailVerified: user.emailVerified,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  // Getter para obtener el nombre del usuario
  String get name => _name;

  // Setter para actualizar el nombre del usuario
  set setName(String newName) {
    _name = newName;
  }

  // Getter para obtener el UID del usuario
  String get userId => _uid;

  // Getter para obtener el email del usuario
  String get userEmail => _email;

  // Getter para verificar si el email del usuario está verificado
  bool get isEmailVerifiedValue => _emailVerified;

  // Método para verificar si el usuario está autenticado
  bool isAuthenticated() {
    return _uid.isNotEmpty;
  }

  // Método para verificar si el correo electrónico del usuario está verificado
  bool isEmailVerified() {
    return _emailVerified;
  }
}
