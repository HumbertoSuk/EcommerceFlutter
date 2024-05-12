import 'package:app_lenses_commerce/presentation/widgets/slideMenu/slide_menu.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  static const String nameScreen = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

//Implementar posteriormente el widget del carousel donde se mostran los productos
//Provisional.

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final List<String> images = [
      'https://devlyn.vtexassets.com/assets/vtex.file-manager-graphql/images/e1104491-9de4-4322-b6ea-df763c51f74e___2967e7b9f44cedcac0cbffab359d074e.jpg',
      'https://devlyn.vtexassets.com/assets/vtex.file-manager-graphql/images/e1104491-9de4-4322-b6ea-df763c51f74e___2967e7b9f44cedcac0cbffab359d074e.jpg',
      'https://devlyn.vtexassets.com/assets/vtex.file-manager-graphql/images/e1104491-9de4-4322-b6ea-df763c51f74e___2967e7b9f44cedcac0cbffab359d074e.jpg',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: CarouselSlider(
        items: images.map((imageUrl) {
          return Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: 200.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 0.8,
        ),
      ),
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
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
              try {
                await FirebaseAuth.instance.signOut();
                context.go('/');
              } catch (e) {
                print('Error al cerrar sesión: $e');
                // Manejar el error si ocurre
              }
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
