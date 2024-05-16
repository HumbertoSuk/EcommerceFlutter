import 'package:app_lenses_commerce/presentation/providers/snackbarMessage_Provider.dart';
import 'package:app_lenses_commerce/presentation/widgets/forms/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatelessWidget {
  static const String nameScreen = 'LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final snackbarProvider = SnackbarProvider(); //instancia de provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Vision plus'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: LoginFormState(
            snackbarProvider: snackbarProvider,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Salir de la pantalla actual
          Future.delayed(const Duration(milliseconds: 200), () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          });
        },
        child: const Icon(Icons.exit_to_app),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
