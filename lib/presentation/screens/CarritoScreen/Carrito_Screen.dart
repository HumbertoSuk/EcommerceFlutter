import 'package:app_lenses_commerce/models/CPModel.dart';
import 'package:app_lenses_commerce/presentation/providers/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({Key? key}) : super(key: key);
  static const String nameScreen = 'Carrito_Screen';

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    final List<CartItem> cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('El carrito está vacío'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text('Producto: ${item.productId}'),
                  subtitle: Text('Cantidad: ${item.quantity}'),
                );
              },
            ),
    );
  }
}
