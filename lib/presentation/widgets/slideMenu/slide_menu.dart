import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lenses_commerce/config/menu/menu_item.dart';
import 'package:go_router/go_router.dart';
import 'package:app_lenses_commerce/presentation/providers/userRoleProvider.dart';

class SideMenu extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SideMenu({Key? key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = GlobalVariables.userRole;
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final destinations = _filterMenuItems(role);

    return NavigationDrawer(
      selectedIndex: 0,
      onDestinationSelected: (value) {
        int realIndex = -1;
        int visibleIndex = 0;
        for (int i = 0; i < destinations.length; i++) {
          if (destinations[i].visible) {
            if (visibleIndex == value) {
              realIndex = i;
              break;
            }
            visibleIndex++;
          }
        }

        if (realIndex != -1) {
          final menuItem = appMenuItems[realIndex];
          context.go(menuItem.link);
          scaffoldKey.currentState?.openEndDrawer();
        }
      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(28, hasNotch ? 0 : 20, 16, 10),
          child: const Text('Pantalla Principal'),
        ),
        ...destinations.take(1).map((dest) {
          if (!dest.visible) return const SizedBox.shrink();
          return NavigationDrawerDestination(
            icon: Icon(dest.item.icon),
            label: Text(dest.item.title),
          );
        }).toList(),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
          child: Text('Configuración de tema'),
        ),
        ...destinations.skip(1).take(1).map((dest) {
          if (!dest.visible) return const SizedBox.shrink();
          return NavigationDrawerDestination(
            icon: Icon(dest.item.icon),
            label: Text(dest.item.title),
          );
        }).toList(),
        if (role == 1) ...[
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
            child: Text('Productos'),
          ),
          ...destinations.skip(2).take(2).map((dest) {
            if (!dest.visible) return const SizedBox.shrink();
            return NavigationDrawerDestination(
              icon: Icon(dest.item.icon),
              label: Text(dest.item.title),
            );
          }).toList(),
        ],
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
          child: Text('General'),
        ),
        ...destinations.skip(4).take(1).map((dest) {
          if (!dest.visible) return const SizedBox.shrink();
          return NavigationDrawerDestination(
            icon: Icon(dest.item.icon),
            label: Text(dest.item.title),
          );
        }).toList(),
      ],
    );
  }

  List<_NavigationDestination> _filterMenuItems(int role) {
    return [
      _NavigationDestination(
        item: appMenuItems[0],
        visible: true,
      ),
      _NavigationDestination(
        item: appMenuItems[1],
        visible: true,
      ),
      _NavigationDestination(
        item: appMenuItems[2],
        visible: role == 1, // Only show if user is admin
      ),
      _NavigationDestination(
        item: appMenuItems[3],
        visible: role == 1, // Only show if user is admin
      ),
      _NavigationDestination(
        item: appMenuItems[4],
        visible: true,
      ),
    ];
  }
}

class _NavigationDestination {
  final MenuItem item;
  final bool visible;

  _NavigationDestination({required this.item, required this.visible});
}
