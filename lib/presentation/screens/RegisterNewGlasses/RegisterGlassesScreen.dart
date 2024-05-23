import 'package:app_lenses_commerce/presentation/providers/snackbarMessage_Provider.dart';
import 'package:app_lenses_commerce/presentation/widgets/forms/add_glasses_form.dart';
import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/presentation/widgets/slideMenu/slide_menu.dart';
import 'package:go_router/go_router.dart';

class RegisterGlassesScreen extends StatelessWidget {
  static const String nameScreen = 'RegisterGlassesScreen';

  const RegisterGlassesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final snackbarProvider =
        SnackbarProvider(); // Instancia del SnackbarProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alta de nuevos articulos +'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/Home');
          },
        ),
      ),
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AddGlassesForms(
            snackbarProvider: snackbarProvider,
          ),
        ),
      ),
    );
  }
}
