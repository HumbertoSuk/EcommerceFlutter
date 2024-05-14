import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_lenses_commerce/presentation/widgets/slideMenu/slide_menu.dart';
import 'package:app_lenses_commerce/config/theme/themeApp.dart';
import 'package:app_lenses_commerce/controllers/glassController.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const String nameScreen = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  // Lista de categorías de lentes con nombres específicos
  final List<String> categories = [
    'Lentes de sol', // Lentes de sol
    'Lentes de lectura', // Lentes de lectura
    'Lentes de contacto', // Lentes de contacto
    // Agregar más categorías si es necesario
  ];

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final List<String> images = [
      // Imágenes del carrusel para cada categoría
      // Agregar las imágenes según cada categoría de lentes
      // Por ejemplo, para la categoría 1 (Lentes de sol)
      'https://devlyn.vtexassets.com/assets/vtex.file-manager-graphql/images/e1104491-9de4-4322-b6ea-df763c51f74e___2967e7b9f44cedcac0cbffab359d074e.jpg',
      'https://devlyn.vtexassets.com/assets/vtex.file-manager-graphql/images/e1104491-9de4-4322-b6ea-df763c51f74e___2967e7b9f44cedcac0cbffab359d074e.jpg',
      'https://devlyn.vtexassets.com/assets/vtex.file-manager-graphql/images/e1104491-9de4-4322-b6ea-df763c51f74e___2967e7b9f44cedcac0cbffab359d074e.jpg',
      // Para la categoría 2 (Lentes de lectura)
      'https://devlyn.vtexassets.com/assets/vtex.file-manager-graphql/images/e1104491-9de4-4322-b6ea-df763c51f74e___2967e7b9f44cedcac0cbffab359d074e.jpg',
      'https://devlyn.vtexassets.com/assets/vtex.file-manager-graphql/images/e1104491-9de4-4322-b6ea-df763c51f74e___2967e7b9f44cedcac0cbffab359d074e.jpg',
      'https://devlyn.vtexassets.com/assets/vtex.file-manager-graphql/images/e1104491-9de4-4322-b6ea-df763c51f74e___2967e7b9f44cedcac0cbffab359d074e.jpg',
      // Para categoria 3:
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
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  categories[index],
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              //--aqui
              CarouselSlider(
                items: images.map((imageUrl) {
                  return GestureDetector(
                    onTap: () {
                      // Navegación a DetailScreen cuando se selecciona una tarjeta
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailScreen()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
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
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
              ),

              //--aqui
            ],
          );
        },
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
                // Cerrar sesión
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
