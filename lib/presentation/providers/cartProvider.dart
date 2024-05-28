import 'package:app_lenses_commerce/controllers/cartController.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final CartController _cartController;

  // Constructor que inicializa el proveedor con un controlador de carrito
  CartProvider(this._cartController);

  // Getter para obtener el controlador de carrito
  CartController get cartController => _cartController;

  // Getter para obtener la lista de productos en el carrito
  List<String> get products => _cartController.products;

  // Método para agregar un producto al carrito
  void addToCart(String product) {
    _cartController.addToCart(product);
    notifyListeners();
  }

  // Método para eliminar un producto del carrito
  void removeFromCart(String product) {
    _cartController.removeFromCart(product);
    notifyListeners();
  }

  // Método para limpiar el carrito
  void clearCart() {
    _cartController.clearCart();
    notifyListeners();
  }

  // Método para obtener la cantidad de productos en el carrito
  int getCartItemCount() {
    return _cartController.getCartItemCount();
  }

  // Método para obtener el total del carrito
  double getTotal() {
    return _cartController.getTotal();
  }
}
