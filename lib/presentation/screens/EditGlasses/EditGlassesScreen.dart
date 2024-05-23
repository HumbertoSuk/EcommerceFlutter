import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/presentation/providers/snackbarMessage_Provider.dart';
import 'package:app_lenses_commerce/presentation/widgets/forms/editExist_GlassesForm.dart';
import 'package:app_lenses_commerce/presentation/widgets/slideMenu/slide_menu.dart';
import 'package:go_router/go_router.dart';

class EditGlassesScreen extends StatelessWidget {
  static const String nameScreen = 'EditGlassesScreen';

  final String glassId; // Agrega la variable para recibir el ID del producto

  const EditGlassesScreen({Key? key, required this.glassId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final snackbarProvider =
        SnackbarProvider(); // Instancia del SnackbarProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar lentes existentes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/edit-delete-lenses');
          },
        ),
      ),
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: EditExistForm(
            snackbarProvider: snackbarProvider,
            glassId: glassId, // Pasa el ID al formulario
          ),
        ),
      ),
    );
  }
}
