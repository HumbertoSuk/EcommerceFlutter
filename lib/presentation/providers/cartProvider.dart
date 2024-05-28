import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProviderProvider = ChangeNotifierProvider<CartProvider>((ref) {
  return CartProvider();
});

class CartProvider extends ChangeNotifier {
  // Ejemplo de datos estáticos, para hacerlo dinámico consulta Firestore y crea BD de carrito por usuario
  // Cada usuario debe tener su propio carrito
  final List<Map<String, dynamic>> _cartItems = [
    {
      'productId': '1',
      'name': 'Lentes de Sol',
      'price': 100.0,
      'image': 'https://via.placeholder.com/50',
      'quantity': 1,
    },
    {
      'productId': '2',
      'name': 'Lentes de Lectura',
      'price': 50.0,
      'image': 'https://via.placeholder.com/50',
      'quantity': 2,
    },
    {
      'productId': '1',
      'name': 'Lentes de Sol',
      'price': 100.0,
      'image': 'https://via.placeholder.com/50',
      'quantity': 1,
    },
    {
      'productId': '2',
      'name': 'Lentes de Lectura',
      'price': 50.0,
      'image': 'https://via.placeholder.com/50',
      'quantity': 2,
    },
    {
      'productId': '1',
      'name': 'Lentes de Sol',
      'price': 100.0,
      'image': 'https://via.placeholder.com/50',
      'quantity': 1,
    },
    {
      'productId': '2',
      'name': 'Lentes de Lectura',
      'price': 50.0,
      'image': 'https://via.placeholder.com/50',
      'quantity': 2,
    },
    {
      'productId': '1',
      'name': 'Lentes de Sol',
      'price': 100.0,
      'image': 'https://via.placeholder.com/50',
      'quantity': 1,
    },
  ];

  final double _shippingCost =
      150.0; // Suponiendo un costo de envío fijo de $10

  List<Map<String, dynamic>> get cartItems => _cartItems;

  double get shippingCost => _shippingCost;

  void addToCart(Map<String, dynamic> product) {
    final index = _cartItems
        .indexWhere((item) => item['productId'] == product['productId']);
    if (index >= 0) {
      _cartItems[index]['quantity'] += 1;
    } else {
      _cartItems.add({...product, 'quantity': 1});
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    final index =
        _cartItems.indexWhere((item) => item['productId'] == productId);
    if (index >= 0) {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity'] -= 1;
      } else {
        _cartItems.removeAt(index);
      }
    }
    notifyListeners();
  }

  double calculateSubtotal() {
    return _cartItems.fold(
        0.0,
        (sum, item) =>
            sum + ((item['price'] ?? 0.0) * (item['quantity'] ?? 1)));
  }

  double calculateTax() {
    // Supongamos que hay un impuesto fijo del 16%
    final subtotal = calculateSubtotal();
    return subtotal * 0.16;
  }

  double calculateTotal() {
    final subtotal = calculateSubtotal();
    final tax = calculateTax();
    return subtotal + tax + _shippingCost;
  }
}
