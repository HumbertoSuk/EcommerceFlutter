import 'package:app_lenses_commerce/models/glassesModel.dart';
import 'package:app_lenses_commerce/presentation/screens/Detail-Home/DetailScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_lenses_commerce/presentation/widgets/slideMenu/slide_menu.dart';
import 'package:app_lenses_commerce/config/theme/themeApp.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const String nameScreen = 'HomeScreen';

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    Future<List<String>> _getCategoriesFromFirestore() async {
      try {
        // Realiza una consulta a Firestore para obtener las categorías de lentes
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('categories')
            .get();

        // Mapea los documentos a una lista de nombres de categorías
       final List<String> categories = querySnapshot.docs.map((doc) {
  return doc.get('name') as String; // Realiza un cast a String
}).toList();


        return categories; // Devuelve la lista de categorías
      } catch (error) {
        // Maneja cualquier error que pueda ocurrir durante la obtención de las categorías
        print('Error al obtener las categorías: $error');
        return []; // Devuelve una lista vacía en caso de error
      }
    }

    Future<List<GlassesModel>> _getProductsForCategory(String category) async {
      try {
        // Realiza una consulta a Firestore para obtener los productos de la categoría especificada
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: category) // Suponiendo 'category' en documentos de producto
            .get();

        // Mapea cada documento a un objeto GlassesModel
        final List<GlassesModel> products = querySnapshot.docs.map((doc) {
          return GlassesModel.fromFirestore(doc);
        }).toList();

        return products; // Devuelve la lista de productos
      } catch (error) {
        // Maneja cualquier error que pueda ocurrir durante la obtención de los productos
        print('Error al obtener los productos: $error');
        return []; // Devuelve una lista vacía en caso de error
      }
    }

    void _navigateToProductDetails(BuildContext context, String productId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(productId: productId),
        ),
      );
    }

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
      body: FutureBuilder<List<String>>(
        future: _getCategoriesFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final categories = snapshot.data ?? [];
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        categories[index],
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    FutureBuilder<List<GlassesModel>>(
                      future: _getProductsForCategory(categories[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final products = snapshot.data ?? [];
                          return CarouselSlider(
                            items: products.map((product) {
                              return GestureDetector(
                                onTap: () {
                                  _navigateToProductDetails(context, product.productId); // Utiliza el contexto del widget actual
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      product.image ?? '', // Utilizar la imagen del producto si está disponible
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
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          }
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
