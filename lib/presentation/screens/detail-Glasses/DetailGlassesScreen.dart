import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/presentation/widgets/forms/detail_form.dart';
import 'package:app_lenses_commerce/presentation/providers/glassesHomeProvider.dart';
import 'package:go_router/go_router.dart';

class DetailScreen extends StatelessWidget {
  static const String nameScreen = 'DetailScreen';
  final String productId;

  const DetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Producto'),
      ),
      body: Column(
        children: [
         /* Expanded(
            child: DetailForm(
             productId: productId,
              addToCart: (int quantity, String productId) {
                // Llama al método addToCart del provider para agregar el producto al carrito.
                Provider.of<GlassesHomeProvider>(context, listen: false)
                    .addToCart(productId, quantity);
              },
            ),
          ),*/
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go('/Home');
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
