import 'package:app_lenses_commerce/presentation/providers/snackbarMessage_Provder.dart';
import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/presentation/widgets/slideMenu/slide_menu.dart';
import 'package:app_lenses_commerce/presentation/widgets/forms/register_form.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  static const String nameScreen = 'RegisterScreen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final snackbarProvider =
        SnackbarProvider(); // Instancia del SnackbarProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Vision plus'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/');
          },
        ),
      ),
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: RegisterForm(snackbarProvider: snackbarProvider),
        ),
      ),
    );
  }
}
