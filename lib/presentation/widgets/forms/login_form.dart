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

class _LoginFormState extends State<LoginFormState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isFilled = ValueNotifier<bool>(false);
  bool isPasswordVisible = false;
  final LoginController _loginController = LoginController();

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
            LogoWidget(
              width: 150,
              height: 150,
              imagePath: 'assets/images/logo.png',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Correo Electrónico',
              obscureText: false,
              controller: emailController,
              onChanged: (_) => _checkFields(),
              errorText: Validations.isEmailValid(emailController.text)
                  ? null
                  : 'Correo electrónico inválido',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Contraseña',
              obscureText: !isPasswordVisible,
              controller: passwordController,
              onChanged: (_) => _checkFields(),
              errorText: Validations.isPasswordValid(passwordController.text)
                  ? null
                  : 'Ingrese Contraseña',
            ),
            const SizedBox(height: 5),
            PasswordVisibilityButton(
              isPasswordVisible: isPasswordVisible,
              onPressed: _togglePasswordVisibility,
            ),
            const SizedBox(height: 20),
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

  void _checkFields() {
    final isValidEmail = Validations.isEmailValid(emailController.text);
    final isValidPassword =
        Validations.isPasswordValid(passwordController.text);
    final isEmailNotEmpty = emailController.text.isNotEmpty;
    final isPasswordNotEmpty = passwordController.text.isNotEmpty;

    setState(() {
      isFilled.value = isValidEmail &&
          isValidPassword &&
          isEmailNotEmpty &&
          isPasswordNotEmpty;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }
}
