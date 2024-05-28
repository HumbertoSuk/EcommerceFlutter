import 'package:flutter_riverpod/flutter_riverpod.dart';

// Definición del StateNotifier// Definición del StateNotifier
class UserRoleNotifier extends StateNotifier<int> {
  UserRoleNotifier() : super(0);

  // Constructor con nombre copyWith para reconstruir el objeto con un nuevo estado
  UserRoleNotifier copyWith(int newState) {
    return UserRoleNotifier()..state = newState;
  }
}

//Variable del rol
class GlobalVariables {
  static int userRole = 0;
}
