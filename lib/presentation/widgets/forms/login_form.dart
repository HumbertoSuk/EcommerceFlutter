import 'package:app_lenses_commerce/controllers/loginController.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lenses_commerce/validation/validation.dart';
import 'package:app_lenses_commerce/presentation/widgets/widgets.dart';

class LoginFormState extends StatefulWidget {
  const LoginFormState({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginFormState> with ValidationMixin {
  // Controladores de texto
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Notifier para ver si esta lleno los campos
  final ValueNotifier<bool> isFilled = ValueNotifier<bool>(false);

  // Visibilidad del pass
  bool isPasswordVisible = false;

  final LoginController _loginController = LoginController();

  String? emailErrorText; // ErrorText para el correo electrónico
  String? passwordErrorText; // ErrorText para la contraseña

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isFilled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de la aplicación.
            const LogoWidget(
              width: 150,
              height: 150,
              imagePath: 'assets/images/logo.png',
            ),
            const SizedBox(height: 20),

            // Campo de texto para el correo electrónico.
            CustomTextField(
              hintText: 'Correo Electrónico',
              obscureText: false,
              controller: emailController,
              onChanged: (_) => _checkFields(),
              // Validación del correo electrónico.
              errorText: emailErrorText,
            ),
            const SizedBox(height: 20),

            // Campo de texto para la contraseña.
            CustomTextField(
              hintText: 'Contraseña',
              obscureText: !isPasswordVisible,
              controller: passwordController,
              onChanged: (_) => _checkFields(),
              // Validación de la contraseña.
              errorText: passwordErrorText,
            ),
            const SizedBox(height: 5),

            // Botón para cambiar la visibilidad de la contraseña.
            PasswordVisibilityButton(
              isPasswordVisible: isPasswordVisible,
              onPressed: _togglePasswordVisibility,
            ),
            const SizedBox(height: 20),

            // Botón para iniciar sesión.
            CustomButton(
              text: 'Iniciar Sesión',
              onPressed: isFilled.value
                  ? () => _loginController.signInWithEmailAndPassword(
                        context: context,
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      )
                  : null,
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: '¿Olvidaste tu contraseña?',
              onPressed: () {
                GoRouter.of(context).go('/ForgotPasswordScreen');
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'No tienes cuenta? Regístrate (≧◡≦) ♡',
              onPressed: () {
                GoRouter.of(context).go('/SignUp');
              },
            ),
          ],
        ),
      ),
    );
  }

  //Verificar campos de texto
  void _checkFields() {
    setState(() {
      emailErrorText = isEmailValid(emailController.text)
          ? null
          : 'Correo electrónico inválido';

      passwordErrorText = isPasswordValid(passwordController.text)
          ? null
          : 'La contraseña no puede estar vacia';

      final isValidEmail = emailErrorText == null;
      final isValidPassword = passwordErrorText == null;
      final isEmailNotEmpty = emailController.text.isNotEmpty;
      final isPasswordNotEmpty = passwordController.text.isNotEmpty;

      isFilled.value = isValidEmail &&
          isValidPassword &&
          isEmailNotEmpty &&
          isPasswordNotEmpty;
    });
  }

  // Método para alternar la visibilidad de la contraseña.
  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }
}
