import 'package:app_lenses_commerce/controllers/loginController.dart';
import 'package:app_lenses_commerce/presentation/widgets/forms/home_form.dart';
import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/presentation/widgets/slideMenu/slide_menu.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const String nameScreen = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.shopping_cart), // Icono del carrito de compras
            onPressed: () {
              // Agrega aquí la lógica para abrir la pantalla del carrito de compras
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: const HomeForm(),
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await LoginController().signOut();
              _handleLogoutResult(context, result);
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  void _handleLogoutResult(BuildContext context, Map<String, dynamic> result) {
    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
        ),
      );
      GoRouter.of(context).go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
        ),
      );
    }
  }
}
