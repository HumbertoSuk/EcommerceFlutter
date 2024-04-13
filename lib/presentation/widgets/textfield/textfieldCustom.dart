import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool? obscureText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.obscureText,
    required this.controller,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
      ),
      textAlign: TextAlign.center,
      obscureText: obscureText ?? false,
    );
  }
}
