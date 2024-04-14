import 'package:flutter/material.dart';

class SnackBarUtils {
  static void showCustomSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
