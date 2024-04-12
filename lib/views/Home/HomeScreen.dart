import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/config/menu/menu_item.dart';
import 'package:app_lenses_commerce/presentation/widgets/slideMenu/slide_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_lenses_commerce/controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  static const String nameScreen = 'HomeScreen';
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              HomeController.logout(
                  context); // Llama al método logout del controlador
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: appMenuItems.length,
        itemBuilder: menuList,
      ),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
    );
  }

  Widget menuList(BuildContext context, int index) {
    final menuItem = appMenuItems[index];
    return _CustomListTitle(menuItem: menuItem);
  }
}

class _CustomListTitle extends StatelessWidget {
  const _CustomListTitle({
    required this.menuItem,
  });

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(menuItem.icon, color: colors.primary),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: colors.primary),
      title: Text(menuItem.title),
      subtitle: Text(menuItem.subtitle),
      onTap: () {
        context.push(menuItem.link);
      },
    );
  }
}
