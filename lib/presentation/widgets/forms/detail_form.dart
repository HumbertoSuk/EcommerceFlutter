import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lenses_commerce/presentation/providers/cartProvider.dart';
import 'package:go_router/go_router.dart';

class DetailForm extends ConsumerStatefulWidget {
  final String productId;

  const DetailForm({Key? key, required this.productId}) : super(key: key);

  @override
  _DetailFormState createState() => _DetailFormState();
}

class _DetailFormState extends ConsumerState<DetailForm> {
  int selectedQuantity = 1;
  bool _buttonPressed =
      false; // Estado para controlar si el botón ha sido presionado

  @override
  Widget build(BuildContext context) {
    final cartProvider = ref.watch(cartProviderProvider);

    ref.read(cartProviderProvider).getProductById(widget.productId);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: cartProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : cartProvider.productData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductImage(cartProvider.productData['image']),
                      const SizedBox(height: 24.0),
                      _buildProductDetails(cartProvider.productData),
                      const SizedBox(height: 24.0),
                      const SizedBox(height: 24.0),
                      _buildAddToCartButton(
                          cartProvider.productData['stock'], cartProvider),
                    ],
                  ),
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.scaleDown,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildErrorImage(),
                )
              : _buildErrorImage(),
        ),
      ),
    );
  }

  Widget _buildErrorImage() {
    return Image.asset(
      'assets/images/no_image_error.png',
      fit: BoxFit.scaleDown,
    );
  }

  Widget _buildProductDetails(Map<String, dynamic> productData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productData['name'] ?? 'Nombre no disponible',
          style: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        _buildProductDetailText('Descripción:',
            productData['description'] ?? 'Descripción no disponible'),
        const SizedBox(height: 16.0),
        _buildProductDetailText(
            'Material:', productData['material'] ?? 'Material no disponible'),
        const SizedBox(height: 16.0),
        _buildProductDetailText(
            'Tipo:', productData['type'] ?? 'Tipo no disponible'),
        const SizedBox(height: 16.0),
        _buildProductDetailText(
            'Color:', productData['color'] ?? 'Color no disponible'),
        const SizedBox(height: 16.0),
        _buildProductDetailText(
            'Stock actual:', productData['stock']?.toString() ?? '0'),
        const SizedBox(height: 16.0),
        _buildProductDetailText(
            'Precio:', '\$${productData['price']?.toString() ?? '0.00'}'),
      ],
    );
  }

  Widget _buildProductDetailText(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: const TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(int stock, CartProvider cartProvider) {
    return Center(
      child: ElevatedButton(
        onPressed: _buttonPressed
            ? null
            : (stock > 0
                ? () => _addToCart(cartProvider)
                : null), // Deshabilitar el botón si _buttonPressed es verdadero
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'Agregar al carrito',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  void _addToCart(CartProvider cartProvider) {
    final productId = widget.productId;
    final productName = cartProvider.productData['name'];
    setState(() {
      _buttonPressed =
          true; // Actualizar el estado de _buttonPressed a verdadero después de presionar el botón
    });
    cartProvider.addToCart(productId).then((_) {
      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$productName se ha añadido a tu carrito.'),
          duration: const Duration(seconds: 2),
        ),
      );

      GoRouter.of(context).go('/Home');
    });
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
