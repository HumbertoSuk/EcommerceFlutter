import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subtitle;
  final String link;
  final String nameScreen;
  final IconData icon;

  const MenuItem({
    required this.nameScreen,
    required this.title,
    required this.subtitle,
    required this.link,
    required this.icon,
  });
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: "Home",
    subtitle: "Pantalla principal de la tienda",
    link: "/Home",
    nameScreen: "HomeScreen",
    icon: Icons.home,
  ),
  MenuItem(
    title: "Cambiar Tema",
    subtitle: "Cambiar el tema de la app",
    link: "/theme-changer",
    nameScreen: "ThemeChangeScreen",
    icon: Icons.palette,
  ),
  MenuItem(
    title: "Añadir lentes",
    subtitle: "Añadir nuevos lentes al catálogo",
    link: "/add-lenses",
    nameScreen: "AddLensesScreen",
    icon: Icons.add,
  ),
  MenuItem(
    title: "Editar/Eliminar lentes",
    subtitle: "Editar o eliminar información de lentes existentes",
    link: "/edit-delete-lenses",
    nameScreen: "EditDeleteLensesScreen",
    icon: Icons.edit,
  ),
  MenuItem(
    title: "Todas las opciones",
    subtitle: "Opciones",
    link: "/Settings",
    nameScreen: "SettingsScreen",
    icon: Icons.settings_input_component_outlined,
  ),
];
