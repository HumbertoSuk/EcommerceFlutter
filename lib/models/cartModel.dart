import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String productId;
  final String productName;
  final double price;
  final String image;
  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.image,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItem(
      productId: doc.id,
      productName: data['productName'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      image: data['image'] ?? '',
      quantity: (data['quantity'] ?? 0) as int,
    );
  }

  CartItem copyWith({required int quantity}) {
    return CartItem(
      productId: this.productId,
      productName: this.productName,
      price: this.price,
      image: this.image,
      quantity: quantity,
    );
  }
}
