import 'package:app_lenses_commerce/models/CPModel.dart';
import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/controllers/cartController.dart';

class CartProvider extends ChangeNotifier {
  final CartController _cartController = CartController(); // Instancia del controlador de carrito

  List<CartItem> get items => _cartController.items; // Getter para obtener todos los items del carrito

  // Métodos para llamar a las funciones del controlador de carrito
  void addItem(CartItem item) {
    _cartController.addItem(item);
    notifyListeners();
  }

  void removeItem(String userId, String productId) {
    _cartController.removeItem(userId, productId);
    notifyListeners();
  }

  void clearCart(String userId) {
    _cartController.clearCart(userId);
    notifyListeners();
  }

  double getTotal(String userId) => _cartController.getTotal(userId);
}
