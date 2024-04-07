import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lenses_commerce/presentation/widgets/slideMenu/slide_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  static const String nameScreen = 'LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Vision plus'),
      ),
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
      ), // Menú lateral
      body: SingleChildScrollView(
        child: LoginForm(), // Formulario de inicio de sesión
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ValueNotifier<bool> isFilled = ValueNotifier<bool>(false);
  bool isPasswordVisible = false;
  bool isEmailValid = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isFilled.dispose();
    super.dispose();
  }

  void checkFields() {
    final isEmailValid = EmailValidator.validate(emailController.text);
    final isPasswordValid = _isPasswordValid(passwordController.text);

    setState(() {
      this.isEmailValid = isEmailValid;
      isFilled.value = isEmailValid && isPasswordValid;
    });
  }

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Verifica si el correo electrónico del usuario está verificado
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        // Si el inicio de sesión es exitoso y el correo electrónico está verificado,
        GoRouter.of(context).go('/Home');
      } else {
        // Si el correo electrónico no está verificado, muestra un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Por favor, verifica tu correo electrónico para iniciar sesión.'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      // Error durante el inicio de sesión
      final errorMessage = e.toString();
      if (errorMessage.contains('credential is incorrect')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Contraseña o usuario incorrectos.'),
          duration: Duration(seconds: 3),
        ));
      } else if (errorMessage
          .contains('blocked all requests from this device')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'EL dispositivo fue bloquedado por actividad sospechosa, intente mas tarde o intente cambiar de contraseña'),
          duration: Duration(seconds: 3),
        ));
      } else {
        // Otro tipo de error, muestra un mensaje de error general
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al iniciar sesión: $e'),
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            const SizedBox(height: 20),
            _buildTextField(
              hintText: 'Correo Electrónico',
              obscureText: false,
              controller: emailController,
              onChanged: (_) => checkFields(),
              errorText: isEmailValid ? null : 'Correo electrónico inválido',
            ),
            const SizedBox(height: 20),
            _buildTextField(
              hintText: 'Contraseña',
              obscureText: !isPasswordVisible,
              controller: passwordController,
              onChanged: (_) => checkFields(),
              errorText: _isPasswordValid(passwordController.text)
                  ? null
                  : 'Ingrese Contraseña',
            ),
            const SizedBox(height: 5),
            _buildPasswordVisibilityButton(),
            const SizedBox(height: 20),
            _buildLoginButton(),
            const SizedBox(height: 10),
            _buildForgotPasswordButton(),
            const SizedBox(height: 10),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      width: 150,
      height: 150,
    );
  }

  Widget _buildTextField({
    required String hintText,
    required bool obscureText,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
      ),
      textAlign: TextAlign.center,
      obscureText: obscureText,
    );
  }

  Widget _buildPasswordVisibilityButton() {
    return IconButton(
      icon: Icon(
        isPasswordVisible ? Icons.visibility_off : Icons.visibility,
      ),
      onPressed: togglePasswordVisibility,
    );
  }

  Widget _buildLoginButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: isFilled,
      builder: (context, filled, _) {
        return ElevatedButton(
          onPressed: filled
              ? () {
                  _signInWithEmailAndPassword(context);
                }
              : null,
          child: const Text('Iniciar Sesión'),
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        GoRouter.of(context).go('/ForgotPasswordScreen');
      },
      child: const Text('¿Olvidaste tu contraseña?'),
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () {
        GoRouter.of(context).go('/SignUp');
      },
      child: const Text('No tienes cuenta? Regístrate (≧◡≦) ♡'),
    );
  }
}
