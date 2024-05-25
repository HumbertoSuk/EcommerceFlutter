import 'package:app_lenses_commerce/presentation/providers/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:app_lenses_commerce/models/CPModel.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = provider.Provider.of<CartProvider>(context); // Obtener el CartProvider del contexto
    final List<CartItem> cartItems = cartProvider.items; // Obtener los elementos del carrito

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text('El carrito está vacío'),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return _buildCartItem(context, item);
              },
            ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    final cartProvider = provider.Provider.of<CartProvider>(context); // Obtener el CartProvider del contexto

    return ListTile(
      title: Text(item.product.name),
      subtitle: Text('Cantidad: ${item.quantity}'),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          //// Llama al método removeItem del CartProvider para eliminar este producto del carrito
          cartProvider.removeItem(item.userId, item.productId);
        },
      ),
    );
  }
}
