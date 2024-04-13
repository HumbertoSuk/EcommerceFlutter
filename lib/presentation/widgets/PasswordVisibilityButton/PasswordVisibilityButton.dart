import 'package:flutter/material.dart';

class PasswordVisibilityButton extends StatelessWidget {
  final bool isPasswordVisible;
  final VoidCallback onPressed;

  const PasswordVisibilityButton({
    Key? key,
    required this.isPasswordVisible,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isPasswordVisible ? Icons.visibility_off : Icons.visibility,
      ),
      onPressed: onPressed,
    );
  }
}
