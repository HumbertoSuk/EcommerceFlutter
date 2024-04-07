import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatelessWidget {
  static const String nameScreen = 'RegisterScreen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RegisterForm();
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isEmailValid = true;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isFieldsValid = false;
  String? passwordErrorText;
  String? confirmPasswordErrorText;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void validateEmail(String value) {
    setState(() {
      isEmailValid = EmailValidator.validate(value);
      _validateFields();
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }

  void _validateFields() {
    final isPasswordSecure = _isPasswordSecure(passwordController.text);
    final isNameValid = !_containsSpecialCharacters(nameController.text);
    final isConfirmPasswordMatch =
        passwordController.text == confirmPasswordController.text;

    setState(() {
      passwordErrorText = isPasswordSecure
          ? null
          : 'Debe tener al menos 8 caracteres y contener números y letras';
      confirmPasswordErrorText =
          isConfirmPasswordMatch ? null : 'Las contraseñas no coinciden';
      isFieldsValid = isNameValid &&
          isEmailValid &&
          isConfirmPasswordMatch &&
          isPasswordSecure;
    });
  }

  bool _isPasswordSecure(String password) {
    return password.length >= 8;
  }

  bool _containsSpecialCharacters(String text) {
    final specialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return specialCharacters.hasMatch(text);
  }

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await userCredential.user!.updateDisplayName(nameController.text);

      await userCredential.user!.sendEmailVerification();

      // Registro exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Registro exitoso. Se ha enviado un correo de verificación.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      GoRouter.of(context).go('/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error durante el registro: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      print('Error during registration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildTextField(
                hintText: 'Username',
                obscureText: false,
                controller: nameController,
                onChanged: (_) => _validateFields(),
                errorText: _containsSpecialCharacters(nameController.text)
                    ? 'El nombre no debe contener caracteres especiales'
                    : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                hintText: 'Correo Electrónico',
                obscureText: false,
                controller: emailController,
                errorText: isEmailValid ? null : 'Correo electrónico inválido',
                onChanged: validateEmail,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                hintText: 'Contraseña',
                obscureText: !isPasswordVisible,
                controller: passwordController,
                onChanged: (_) => _validateFields(),
                errorText: passwordErrorText,
              ),
              IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: togglePasswordVisibility,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                hintText: 'Confirmar Contraseña',
                obscureText: !isConfirmPasswordVisible,
                controller: confirmPasswordController,
                onChanged: (_) => _validateFields(),
                errorText: confirmPasswordErrorText,
              ),
              IconButton(
                icon: Icon(
                  isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: toggleConfirmPasswordVisibility,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isFieldsValid ? _register : null,
                child: const Text('Crear Cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required bool obscureText,
    required TextEditingController controller,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
      ),
      obscureText: obscureText,
    );
  }
}
