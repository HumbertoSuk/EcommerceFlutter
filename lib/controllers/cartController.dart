import 'package:flutter/material.dart';

class CartController {
  // Lista de productos en el carrito
  List<String> _products = [];

  // Getter para obtener la lista de productos en el carrito
  List<String> get products => _products;

  // Método para agregar un producto al carrito
  void addToCart(String product) {
    _products.add(product);
  }

  // Método para eliminar un producto del carrito
  void removeFromCart(String product) {
    _products.remove(product);
  }

  // Método para limpiar el carrito
  void clearCart() {
    _products.clear();
  }

  // Método para obtener la cantidad de productos en el carrito
  int getCartItemCount() {
    return _products.length;
  }

  // Método para obtener el total del carrito
  double getTotal() {
    // Simplemente sumamos el precio de cada producto en el carrito
    double total = 0;
    for (String product in _products) {
      // Aquí asumimos que el precio de cada producto es 10, por ejemplo
      total += 10;
    }
    return total;
  }
}
