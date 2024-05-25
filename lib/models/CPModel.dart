import 'package:cloud_firestore/cloud_firestore.dart';
import 'glassesModel.dart';

class CartItem {
  final String productId;
  final GlassesModel product;
  final String userId;  // Nuevo campo para almacenar el UID del usuario
  int quantity;

  CartItem({
    required this.productId,
    required this.product,
    required this.userId,  // Asegurarse de pasar el UID del usuario al crear un CartItem
    this.quantity = 1,
  });

  // Método para convertir el CartItem a un mapa
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'product': product.toMap(),
      'userId': userId,  // Incluir el UID del usuario en el mapa
      'quantity': quantity,
    };
  }

  // Método para crear un CartItem desde un mapa
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'],
      product: GlassesModel.fromJson(map['product']),
      userId: map['userId'],  // Obtener el UID del usuario del mapa
      quantity: map['quantity'],
    );
  }
}
