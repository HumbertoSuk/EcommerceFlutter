import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app_lenses_commerce/presentation/widgets/forms/ForgotPasswordForm.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String nameScreen = 'ForgotPasswordScreen';

  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/');
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ForgotPasswordForm(),
        ),
      ),
    );
  }
}
