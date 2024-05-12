import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool? obscureText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.obscureText,
    required this.controller,
    required this.onChanged,
    this.errorText,
    this.keyboardType,
    this.suffixIcon,
    this.maxLines,
    this.maxLength,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        suffixIcon: suffixIcon,
      ),
      textAlign: TextAlign.center,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters,
      maxLines: obscureText != null && obscureText! ? 1 : maxLines,
    );
  }
}
