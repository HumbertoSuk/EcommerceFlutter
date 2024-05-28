import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  static const String nameScreen = 'cartScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
      ),
      body: Center(
        child: Text(
          'Hola',
          style: TextStyle(
            fontSize: 24, // Tamaño de fuente grande
            color: Colors.black, // Color de texto negro
          ),
        ),
      ),
    );
  }
}
