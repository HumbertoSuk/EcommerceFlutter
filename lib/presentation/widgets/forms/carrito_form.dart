import 'package:app_lenses_commerce/models/CPModel.dart';
import 'package:app_lenses_commerce/models/glassesModel.dart';
import 'package:app_lenses_commerce/presentation/providers/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarritoForm extends StatefulWidget {
  final String userId;
  final String productId;
  final GlassesModel product;

  const CarritoForm({
    Key? key,
    required this.userId,
    required this.productId,
    required this.product,
  }) : super(key: key);

  @override
  _CarritoFormState createState() => _CarritoFormState();
}

class _CarritoFormState extends State<CarritoForm> {
  late TextEditingController _quantityController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addToCart(context),
                child: const Text('Agregar al carrito'),
              ),
            ],
          );
  }

  void _addToCart(BuildContext context) {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    if (quantity <= 0) {
      // Manejo de error si la cantidad es inválida
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cantidad inválida')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final cartProvider = context.read<CartProvider>();

    // Crear un CartItem y agregarlo al carrito
    final cartItem = CartItem(
      userId: widget.userId,
      productId: widget.productId,
      quantity: quantity,
      product: widget.product,
    );

    cartProvider.addItem(cartItem);

    setState(() {
      _isLoading = false;
    });

    // Limpiar el campo de cantidad después de agregar al carrito
    _quantityController.clear();

    // Notificar al usuario que se agregó al carrito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto agregado al carrito')),
    );
  }
}
