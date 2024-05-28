import 'package:app_lenses_commerce/presentation/providers/notification_provider.dart';
import 'package:app_lenses_commerce/presentation/providers/userRoleProvider.dart';
import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/controllers/loginController.dart';
import 'package:app_lenses_commerce/helpers/validation/validation.dart';
import 'package:app_lenses_commerce/presentation/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lenses_commerce/presentation/providers/snackbarMessage_Provider.dart';

class LoginFormState extends StatefulWidget {
  final UserRoleNotifier roleProvider;
  final SnackbarProvider snackbarProvider; // Cambiar aquí

  const LoginFormState({
    Key? key,
    required this.roleProvider,
    required this.snackbarProvider, // Cambiar aquí
  }) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();

  static void handleNotificationData(Map<String, dynamic> notificationData) {}
}

class _LoginFormState extends State<LoginFormState> with ValidationMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController _loginController = LoginController();
  bool isPasswordVisible = false;

  final ValueNotifier<bool> isFilled = ValueNotifier<bool>(false);

  String? emailErrorText;
  String? passwordErrorText;
  final userRole = GlobalVariables.userRole;
  late NotificationProvider _notificationProvider;

  @override
  void initState() {
    super.initState();
    _notificationProvider =
        NotificationProvider(context, widget.snackbarProvider);
    _notificationProvider.initNotification();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoWidget(
              width: 150,
              height: 150,
              imagePath: 'assets/images/logo.png',
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Correo Electrónico',
              obscureText: false,
              controller: emailController,
              onChanged: (_) => _validateFields(),
              errorText: emailErrorText,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Contraseña',
              obscureText: !isPasswordVisible,
              controller: passwordController,
              onChanged: (_) => _validateFields(),
              errorText: passwordErrorText,
            ),
            const SizedBox(height: 20),
            PasswordVisibilityButton(
              isPasswordVisible: isPasswordVisible,
              onPressed: _togglePasswordVisibility,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Iniciar Sesión',
              onPressed: isFilled.value ? () => _signIn(context) : null,
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

  void _validateFields() {
    setState(() {
      emailErrorText = isEmailValid(emailController.text)
          ? null
          : 'Correo electrónico inválido';

      passwordErrorText = isPasswordValid(passwordController.text)
          ? null
          : 'La contraseña no puede estar vacía';

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

  _signIn(BuildContext context) async {
    final result = await _loginController.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (result['success']) {
      final userRole = result['userRole']; // Obtener el rol del resultado
      try {
        GlobalVariables.userRole = userRole;

        // Actualizar el rol utilizando el proveedor
        final roleProvider = UserRoleNotifier();
        final newRoleProvider = roleProvider.copyWith(userRole);
      } catch (e) {}
    }

    _signInCallback(result['success'], result['message']);
  }

  _signInCallback(bool isSuccess, String message) {
    if (isSuccess) {
      widget.snackbarProvider.showSnackbar(context, message);
      GoRouter.of(context).go('/Home');
      FocusScope.of(context).unfocus();
    } else {
      widget.snackbarProvider.showSnackbar(context, message);
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  void dispose() {
    _notificationProvider.dispose();
    super.dispose();
  }
}
