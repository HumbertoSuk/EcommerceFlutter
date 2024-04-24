import 'package:flutter/material.dart';

class SnackBarUtils {
  static void showCustomSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration ??
          const Duration(
              seconds:
                  5), // Utilizamos el valor predeterminado de 5 segundos si es null
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
