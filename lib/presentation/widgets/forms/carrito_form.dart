import 'package:app_lenses_commerce/models/CPModel.dart';
import 'package:app_lenses_commerce/presentation/providers/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarritoForm extends StatefulWidget {
  const CarritoForm({Key? key}) : super(key: key);

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
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Cantidad'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addToCart(context),
                child: Text('Agregar al carrito'),
              ),
            ],
          );
  }

  void _addToCart(BuildContext context) {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    if (quantity <= 0) {
      // Manejo de error si la cantidad es inválida
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final cartProvider = context.read<CartProvider>();

    // Lógica para agregar el producto al carrito
    // Puedes implementar esto según tu lógica específica

    setState(() {
      _isLoading = false;
    });

    // Limpiar el campo de cantidad después de agregar al carrito
    _quantityController.clear();
  }
}
