import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/presentation/providers/snackbarMessage_Provider.dart';
import 'package:app_lenses_commerce/presentation/providers/searchEditDele_Provider.dart';
import 'package:app_lenses_commerce/presentation/widgets/forms/editDele_Glasses_form.dart';
import 'package:app_lenses_commerce/presentation/widgets/slideMenu/slide_menu.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lenses_commerce/controllers/editDeleteGlassesController.dart';

class EditDeleteScreen extends StatelessWidget {
  static const String nameScreen = 'EditDeleteLensesScreen';

  const EditDeleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final snackbarProvider = SnackbarProvider();
    final glassController = GlassController();
    final searchControllerProvider = SearchEditDeleteProvider(glassController);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar y eliminar'),
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
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: EditDeleteGlassesForm(
              snackbarProvider: snackbarProvider,
              searchControllerProvider: searchControllerProvider,
            ),
          ),
        ),
      ),
    );
  }
}
