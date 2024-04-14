import 'package:app_lenses_commerce/controllers/forgotPassController.dart';
import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/presentation/widgets/widgets.dart';
import 'package:app_lenses_commerce/validation/validation.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm>
    with ValidationMixin {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ForgotPasswordController _forgotPasswordController =
      ForgotPasswordController();

  String? emailErrorText; // ErrorText para el correo electrónico
  bool isButtonEnabled = false; // Estado del botón

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            hintText: 'Correo Electrónico',
            controller: emailController,
            onChanged: (_) => setState(() {
              emailErrorText = null; // Reiniciar el mensaje de error
              updateButtonState();
            }),
            // Validación del correo electrónico.
            errorText: emailErrorText,
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Recuperar Contraseña',
            onPressed: isButtonEnabled ? () => resetPassword() : null,
          ),
        ],
      ),
    );
  }

  // Método para actualizar el estado del botón
  void updateButtonState() {
    setState(() {
      if (emailController.text.isNotEmpty &&
          !isEmailValid(emailController.text)) {
        emailErrorText = 'Por favor ingrese un correo electrónico válido';
      } else {
        emailErrorText = null;
      }
      isButtonEnabled = emailErrorText == null;
    });
  }

  // Método para resetear la contraseña
  void resetPassword() {
    _forgotPasswordController.resetPassword(
      context,
      emailController.text,
    );
  }
}
