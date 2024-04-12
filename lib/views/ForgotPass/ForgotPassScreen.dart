import 'package:app_lenses_commerce/controller/forgot_pass_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/controllers/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String nameScreen = 'ForgotPasswordScreen';

  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
        // Agregar botón de regreso a la raíz
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: ForgotPasswordForm(controller: ForgotPasswordController()),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  final ForgotPasswordController controller;

  const ForgotPasswordForm({Key? key, required this.controller})
      : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isEmailValid = true;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void validateEmail(String value) {
    setState(() {
      isEmailValid = EmailValidator.validate(value);
    });
  }

  void _resetPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      widget.controller.resetPassword(emailController.text, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Correo Electrónico',
              hintText: 'Ingrese su correo electrónico',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su correo electrónico';
              }
              if (!isEmailValid) {
                return 'Por favor ingrese un correo electrónico válido';
              }
              return null;
            },
            onChanged: validateEmail,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _resetPassword(context);
            },
            child: Text('Recuperar Contraseña'),
          ),
        ],
      ),
    );
  }
}
