// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:app_lenses_commerce/models/cartModel.dart';
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

    // Llama al método init al construir el widget
    cartProvider.init();

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
                  return _buildCartItem(context, cartProvider, cartItem, index);
                },
              ),
            ),
            _buildCartSummary(cartProvider),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: cartProvider.cartItems.isEmpty
                  ? null
                  : () {
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

  Widget _buildCartItem(BuildContext context, CartProvider cartProvider,
      CartItem cartItem, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: _buildCartItemImage(cartItem),
        title: Text(cartItem.productName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Precio: ${cartItem.price}'),
            Text('Cantidad: ${cartItem.quantity}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDeleteCartItemButton(
                context, cartProvider, cartItem.productId),
            _buildRemoveCartItemButton(
                context, cartProvider, cartItem.productId),
            _buildAddCartItemButton(context, cartProvider, cartItem.productId),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoveCartItemButton(
      BuildContext context, CartProvider cartProvider, String productId) {
    return IconButton(
      icon: const Icon(Icons.remove_circle_outline),
      onPressed: () async {
        // Remover una unidad del item del carrito
        await Future.delayed(const Duration(milliseconds: 500));
        cartProvider.removeFromCart(productId);
      },
    );
  }

  Widget _buildAddCartItemButton(
      BuildContext context, CartProvider cartProvider, String productId) {
    return IconButton(
      icon: const Icon(Icons.add_circle_outline),
      onPressed: () async {
        // Añadir una unidad del item al carrito
        await Future.delayed(const Duration(milliseconds: 500));
        cartProvider.addToCart(productId);
      },
    );
  }

  Widget _buildDeleteCartItemButton(
      BuildContext context, CartProvider cartProvider, String productId) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        // Eliminar el item del carrito por completo
        await Future.delayed(const Duration(milliseconds: 500));
        cartProvider.removeItemFromCart(productId);
      },
    );
  }

  Widget _buildCartItemImage(CartItem cartItem) {
    return Image.network(
      cartItem.image,
      width: 80,
      height: 60,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/no_image_error.png',
          width: 80,
          height: 60,
        );
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

  void _completePurchase(
      BuildContext context, CartProvider cartProvider) async {
    final subtotal = cartProvider.calculateSubtotal();
    final tax = cartProvider.calculateTax();
    final shipping = cartProvider.shippingCost;
    final total = cartProvider.calculateTotal();

    _showPurchaseDialog(context, cartProvider, subtotal, tax, shipping, total);
  }

  void _showPurchaseDialog(BuildContext context, CartProvider cartProvider,
      double subtotal, double tax, double shipping, double total) {
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
              _buildPurchaseDetails(subtotal, tax, shipping, total),
              const SizedBox(height: 10),
              _buildActionButtons(context, cartProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseDetails(
    double subtotal,
    double tax,
    double shipping,
    double total,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, CartProvider cartProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar (ಥ﹏ಥ)'),
        ),
        const SizedBox(width: 14),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            final result = await cartProvider.processPurchase();
            if (result['success']) {
              // Limpiar el carrito al confirmar la compra con éxito
              await cartProvider.clearCartUser();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result['message']),
                ),
              );
            }
          },
          child: const Text(
            'Confirmar (≧◡≦)',
          ),
        ),
      ],
    );
  }
}
