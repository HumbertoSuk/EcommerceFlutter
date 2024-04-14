import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool? obscureText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final Widget? suffixIcon; // Nuevo atributo para el icono al final

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.obscureText,
    required this.controller,
    required this.onChanged,
    this.errorText,
    this.suffixIcon, // Agregar el nuevo atributo al constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        suffixIcon: suffixIcon, // Utilizar el atributo suffixIcon
      ),
      textAlign: TextAlign.center,
      obscureText: obscureText ?? false,
    );
  }
}
