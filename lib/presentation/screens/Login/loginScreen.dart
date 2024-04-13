import 'package:app_lenses_commerce/presentation/widgets/forms/login_form.dart';
import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/presentation/widgets/slideMenu/slide_menu.dart';

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
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: LoginFormState(),
        ),
      ),
    );
  }
}
