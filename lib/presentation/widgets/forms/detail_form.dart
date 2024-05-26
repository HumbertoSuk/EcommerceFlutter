import 'package:app_lenses_commerce/models/CPModel.dart';
import 'package:app_lenses_commerce/models/glassesModel.dart';
import 'package:app_lenses_commerce/presentation/providers/cartProvider.dart';
import 'package:app_lenses_commerce/presentation/providers/glassesHomeProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailForm extends StatefulWidget {
  final String productId;

  const DetailForm({Key? key, required this.productId}) : super(key: key);

  @override
  _DetailFormState createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {
  late Map<String, dynamic> _productData = {};
  int _quantity = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  void _fetchProduct() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = GlassesHomeProvider();
      await provider.fetchLensTypes();

      if (provider.lensTypes.isNotEmpty) {
        final productData = await provider.getProductById(widget.productId);
        setState(() {
          _productData = productData;
        });
      } else {
        _showErrorDialog('No hay tipos de lentes disponibles');
      }
    } catch (e) {
      _showErrorDialog('Error al obtener productos: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(_productData['image']),
                const SizedBox(height: 24.0),
                _buildProductDetails(_productData),
                const SizedBox(height: 24.0),
                _buildQuantitySelector(_productData['stock']),
                const SizedBox(height: 24.0),
                _buildAddToCartButton(context, _productData['stock']),
              ],
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
          productData['name'],
          style: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        _buildProductDetailText('Descripción:', productData['description']),
        const SizedBox(height: 16.0),
        _buildProductDetailText('Material:', productData['material']),
        const SizedBox(height: 16.0),
        _buildProductDetailText('Tipo:', productData['type']),
        const SizedBox(height: 16.0),
        _buildProductDetailText('Color:', productData['color']),
        const SizedBox(height: 16.0),
        _buildProductDetailText(
            'Stock actual:', productData['stock'].toString()),
        const SizedBox(height: 16.0),
        _buildProductDetailText(
          'Precio:',
          '\$${productData['price']}',
        ),
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

  Widget _buildQuantitySelector(int stock) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              if (_quantity > 1) {
                _quantity--;
              }
            });
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            '$_quantity',
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              if (_quantity < stock) {
                _quantity++;
              } else {
                _showStockErrorDialog();
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context, int stock) {
    final user = FirebaseAuth.instance.currentUser;
    return Center(
      child: ElevatedButton(
        onPressed: (stock > 0 && user != null)
            ? () {
                final cartProvider = context.read<CartProvider>();

                final cartItem = CartItem(
                  productId: _productData['productId'],
                  product: GlassesModel.fromJson(_productData),
                  userId: user.uid,
                  quantity: _quantity,
                );
                cartProvider.addItem(cartItem);

                // Mostrar el mensaje al usuario
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Producto agregado al carrito'),
                  ),
                );
              }
            : null,
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
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

  void _showStockErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content:
              const Text('La cantidad seleccionada supera el stock disponible'),
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
