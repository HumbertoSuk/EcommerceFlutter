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
    title: "Cambiar Tema",
    subtitle: "cambiar el tema de la app",
    link: "/theme-changer",
    nameScreen: "ThemeChangeScreen",
    icon: Icons.palette,
  )
];
