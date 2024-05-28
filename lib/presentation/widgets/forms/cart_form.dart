import 'package:app_lenses_commerce/presentation/providers/cartProvider.dart';
import 'package:app_lenses_commerce/presentation/providers/snackbarMessage_Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartForm extends ConsumerWidget {
  const CartForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProvider = ref.watch(cartProviderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/Home');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartProvider.cartItems[index];
                  return _buildCartItem(cartProvider, cartItem, index);
                },
              ),
            ),
            _buildCartSummary(cartProvider),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Acción para finalizar la compra
                _completePurchase(context, cartProvider);
              },
              child: const Text('Finalizar Compra'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(
      CartProvider cartProvider, Map<String, dynamic> cartItem, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: _buildCartItemImage(cartItem),
        title: Text(cartItem['name'] ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Precio: ${cartItem['price'] ?? ''}'),
            Text('Cantidad: ${cartItem['quantity'] ?? 1}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRemoveCartItemButton(cartProvider, cartItem, index),
            _buildAddCartItemButton(cartProvider, cartItem),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemImage(Map<String, dynamic> cartItem) {
    return Image.network(
      cartItem['image'] ?? '',
      width: 50,
      height: 50,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/no_image_error.png',
          width: 50,
          height: 50,
        );
      },
    );
  }

  Widget _buildRemoveCartItemButton(
      CartProvider cartProvider, Map<String, dynamic> cartItem, int index) {
    return IconButton(
      icon: const Icon(Icons.remove_circle_outline),
      onPressed: () {
        // Remover una unidad del item del carrito
        cartProvider.removeFromCart(cartItem['productId']);
      },
    );
  }

  Widget _buildAddCartItemButton(
      CartProvider cartProvider, Map<String, dynamic> cartItem) {
    return IconButton(
      icon: const Icon(Icons.add_circle_outline),
      onPressed: () {
        // Añadir una unidad del item al carrito
        cartProvider.addToCart(cartItem);
      },
    );
  }

  Widget _buildCartSummary(CartProvider cartProvider) {
    final subtotal = cartProvider.calculateSubtotal();
    final tax = cartProvider.calculateTax();
    final shipping = cartProvider.shippingCost;
    final total = cartProvider.calculateTotal();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        Text('Impuesto (16%): \$${tax.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        Text('Envío: \$${shipping.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        Text('Total: \$${total.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _completePurchase(BuildContext context, CartProvider cartProvider) {
    final subtotal = cartProvider.calculateSubtotal();
    final tax = cartProvider.calculateTax();
    final shipping = cartProvider.shippingCost;
    final total = cartProvider.calculateTotal();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Finalizar Compra',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 2),
              Text('Impuesto (16%): \$${tax.toStringAsFixed(2)}'),
              const SizedBox(height: 2),
              Text('Envío: \$${shipping.toStringAsFixed(2)}'),
              const SizedBox(height: 6),
              Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar (ಥ﹏ಥ)'),
                  ),
                  const SizedBox(width: 14),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      GoRouter.of(context).go('/Home');
                      SnackbarProvider().showSnackbar(
                        context,
                        'Tu compra ha sido completada',
                      );
                    },
                    child: const Text(
                      'Confirmar (≧◡≦)',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
