import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatelessWidget {
  final String productId;

  const DetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Producto'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(child: Text('No se encontraron datos'));
          }

          // Extraer los datos del documento del producto
          final productData = snapshot.data!.data() as Map<String, dynamic>;

          // Construir la interfaz de usuario con los detalles del producto
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  productData['image'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16.0),
                Text(
                  productData['name'],
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Descripción: ${productData['description']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Material: ${productData['material']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Color: ${productData['color']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Precio: \$${productData['price']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Stock: ${productData['stock']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                // Agregar más detalles según sea necesario
              ],
            ),
          );
        },
      ),
    );
  }
}
