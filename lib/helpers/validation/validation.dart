import 'package:email_validator/email_validator.dart';

// Mixin para proporcionar funciones de validación reutilizables
mixin ValidationMixin {
  // Función para verificar si una contraseña no está vacía
  bool isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  // Función para verificar si un correo electrónico es válido
  bool isEmailValid(String email) {
    return EmailValidator.validate(email);
  }

  // Función para verificar si una contraseña cumple con ciertos criterios de seguridad
  bool isPasswordValidRegister(String password) {
    // RegEx para una contraseña más fuerte
    return password.isNotEmpty &&
        password.length >= 8 &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[a-zA-Z]').hasMatch(password) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  // Función para verificar si un nombre no está vacío y no contiene caracteres especiales
  bool isNameValid(String name) {
    // Validaciones para el nombre de usuario
    return name.isNotEmpty && !containsSpecialCharacters(name);
  }

  // Función para verificar si un texto contiene caracteres especiales
  bool containsSpecialCharacters(String text) {
    final specialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return specialCharacters.hasMatch(text);
  }

  // Función para verificar si un texto contiene ciertos caracteres gramaticales
  bool isTextGrammatical(String text) {
    final specialCharacters = RegExp(r'[#%^&*":{}|<>]');
    return specialCharacters.hasMatch(text);
  }

  // Función para verificar si un valor de stock es válido
  bool isValidStock(String stock) {
    return stock.isNotEmpty &&
        int.tryParse(stock) != null &&
        int.parse(stock) >= 0;
  }

  // Función para verificar si un valor de stock mínimo es válido
  bool isValidStockMin(String stockMin, String stock) {
    return stockMin.isNotEmpty &&
        int.tryParse(stockMin) != null &&
        int.parse(stockMin) >= 0 &&
        int.parse(stockMin) <= (stock.isNotEmpty ? int.parse(stock) : 0);
  }

  // Función para verificar si un valor de stock máximo es válido
  bool isValidStockMax(String stockMax, String stock) {
    return stockMax.isNotEmpty &&
        int.tryParse(stockMax) != null &&
        int.parse(stockMax) >= 0 &&
        int.parse(stockMax) >= (stock.isNotEmpty ? int.parse(stock) : 0);
  }

  // Función para verificar si un precio es válido
  bool isValidPrice(String value) {
    if (value.isEmpty) {
      return false;
    } else {
      final double? price = double.tryParse(value.replaceAll(',', '.'));
      return price != null && price > 0;
    }
  }

// Función para verificar si una URL es válida
  bool isValidUrl(String url) {
    if (url.isEmpty) {
      return false;
    } else {
      //implementar un regex si lo vemos necesario
      return true;
    }
  }
}
