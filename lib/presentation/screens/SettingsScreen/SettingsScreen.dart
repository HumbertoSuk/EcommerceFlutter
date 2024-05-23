import 'package:app_lenses_commerce/config/menu/menu_item.dart';
import 'package:app_lenses_commerce/presentation/widgets/slideMenu/slide_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  static const String nameScreen = 'SettingsScreen';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opciones y configuraciones'),
      ),
      body: ListView.builder(
        itemCount: appMenuItems.length,
        itemBuilder: (context, index) {
          final menuItem = appMenuItems[index];
          // Excluir el menú "Todas las opciones" de la lista
          if (menuItem.title != 'Todas las opciones') {
            return _buildMenuList(context, menuItem);
          } else {
            return const SizedBox.shrink(); // Devolver un widget vacío
          }
        },
      ),
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
      ),
    );
  }

  Widget _buildMenuList(BuildContext context, MenuItem menuItem) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(menuItem.icon, color: colors.primary),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      title: Text(menuItem.title),
      subtitle: Text(menuItem.subtitle),
      onTap: () {
        context.push(menuItem.link);
      },
    );
  }
}
