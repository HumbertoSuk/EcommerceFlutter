import 'package:app_lenses_commerce/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/presentation/providers/snackbarMessage_Provider.dart';
import 'package:app_lenses_commerce/helpers/validation/validation.dart';
import 'package:app_lenses_commerce/controllers/register_controller.dart';
import 'package:go_router/go_router.dart';

class RegisterForm extends StatefulWidget {
  final SnackbarProvider snackbarProvider;

  const RegisterForm({Key? key, required this.snackbarProvider})
      : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> with ValidationMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isFieldsValid = false;
  String? passwordErrorText;
  String? confirmPasswordErrorText;
  String? emailErrorText;

  final RegisterController _registerController = RegisterController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'Username',
            obscureText: false,
            controller: nameController,
            onChanged: (_) => _validateFields(),
            errorText: containsSpecialCharacters(nameController.text)
                ? 'El nombre no debe contener caracteres especiales'
                : null,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'Correo Electrónico',
            obscureText: false,
            controller: emailController,
            errorText: emailErrorText,
            onChanged: (_) => _validateFields(),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'Contraseña',
            obscureText: !isPasswordVisible,
            controller: passwordController,
            onChanged: (_) => _validateFields(),
            errorText: passwordErrorText,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: _togglePasswordVisibility,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: 'Confirmar Contraseña',
            obscureText: !isConfirmPasswordVisible,
            controller: confirmPasswordController,
            onChanged: (_) => _validateFields(),
            errorText: confirmPasswordErrorText,
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: _toggleConfirmPasswordVisibility,
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            onPressed: isFieldsValid ? _register : null,
            text: 'Crear Cuenta',
          ),
        ],
      ),
    );
  }

  _register() async {
    final result = await _registerController.register(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    _registrationCallback(
      result['success'],
      result['email'],
      result['errorMessage'],
    );
  }

  _registrationCallback(
    bool isSuccess,
    String? email,
    String? errorMessage,
  ) {
    if (isSuccess) {
      widget.snackbarProvider.showSnackbar(
        context,
        'Registro exitoso. Se ha enviado un correo de verificación a $email',
      );

      GoRouter.of(context).go('/');
    } else {
      widget.snackbarProvider.showSnackbar(
        context,
        'Error durante el registro: $errorMessage',
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateFields() {
    final isPasswordSecure = isPasswordValidRegister(passwordController.text);
    final isNameValid = !containsSpecialCharacters(nameController.text);
    final isConfirmPasswordMatch =
        passwordController.text == confirmPasswordController.text;

    setState(() {
      passwordErrorText = isPasswordSecure
          ? null
          : 'Debe contener 8 caracteres, números y caracteres especiales';
      confirmPasswordErrorText =
          isConfirmPasswordMatch ? null : 'Las contraseñas no coinciden';
      emailErrorText = isEmailValid(emailController.text)
          ? null
          : 'Correo electrónico inválido';
      isFieldsValid = isNameValid &&
          isEmailValid(emailController.text) &&
          isConfirmPasswordMatch &&
          isPasswordSecure;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }
}
