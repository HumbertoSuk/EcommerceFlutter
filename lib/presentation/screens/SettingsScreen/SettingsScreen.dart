import 'package:app_lenses_commerce/presentation/providers/userRoleProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lenses_commerce/config/menu/menu_item.dart';
import 'package:app_lenses_commerce/presentation/widgets/slideMenu/slide_menu.dart';

class SettingsScreen extends ConsumerWidget {
  // Nombre de la pantalla
  static const String nameScreen = 'SettingsScreen';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    // Filtrar los elementos del menú basado en el rol del usuario
    final filteredMenuItems =
        List<MenuItem>.unmodifiable(_filterMenuItems(GlobalVariables.userRole));

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Opciones y configuraciones'),
      ),
      body: ListView.builder(
        itemCount: filteredMenuItems.length,
        itemBuilder: (context, index) =>
            _buildMenuList(context, filteredMenuItems[index]),
      ),
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
      ),
    );
  }

  // Método para filtrar elementos del menú basados en el rol del usuario
  List<MenuItem> _filterMenuItems(int role) {
    // Elementos que se excluirán del menú según el rol del usuario
    final titlesToExclude = role == 1
        ? ['Todas las opciones']
        : ['Todas las opciones', 'Añadir lentes', 'Editar/Eliminar lentes'];
    // Filtrar los elementos del menú
    return appMenuItems
        .where((item) => !titlesToExclude.contains(item.title))
        .toList();
  }

  // Método para construir la lista de menú
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
