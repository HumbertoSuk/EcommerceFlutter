import 'package:app_lenses_commerce/controllers/forgotPassController.dart';
import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/presentation/widgets/widgets.dart';
import 'package:app_lenses_commerce/validation/validation.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ForgotPasswordController _forgotPasswordController =
      ForgotPasswordController();

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
            onChanged: (_) => setState(() {}),
            errorText: !Validations.isEmailValid(emailController.text)
                ? 'Por favor ingrese un correo electrónico válido'
                : null,
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Recuperar Contraseña',
            onPressed: Validations.isEmailValid(emailController.text)
                ? () => _forgotPasswordController.resetPassword(
                      context,
                      emailController.text,
                    )
                : null,
          ),
        ],
      ),
    );
  }
}
