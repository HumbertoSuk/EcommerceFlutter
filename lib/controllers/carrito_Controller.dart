import 'package:app_lenses_commerce/models/CPModel.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, List<CartItem>> _userCarts = {};  // Map para almacenar carritos por usuario

  List<CartItem> getItems(String userId) => _userCarts[userId] ?? [];

  // Agregar un producto al carrito
  void addItem(CartItem item) {
    final userId = item.userId;
    if (!_userCarts.containsKey(userId)) {
      _userCarts[userId] = [];
    }

    final userCart = _userCarts[userId]!;
    final index = userCart.indexWhere((cartItem) => cartItem.productId == item.productId);
    if (index >= 0) {
      userCart[index].quantity += item.quantity;
    } else {
      userCart.add(item);
    }
    notifyListeners();
  }

  // Eliminar un producto del carrito
  void removeItem(String userId, String productId) {
    _userCarts[userId]?.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  // Limpiar el carrito
  void clearCart(String userId) {
    _userCarts[userId]?.clear();
    notifyListeners();
  }

  // Obtener el total del carrito
  double getTotal(String userId) {
    double total = 0.0;
    final userCart = _userCarts[userId] ?? [];
    for (var item in userCart) {
      total += item.product.price * item.quantity;
    }
    return total;
  }
}
