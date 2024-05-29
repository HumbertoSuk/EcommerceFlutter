import 'package:app_lenses_commerce/models/cartModel.dart';
import 'package:app_lenses_commerce/models/glassesModel.dart';
import 'package:flutter/material.dart';

class CartController {
  final List<CartModel> _cartItems = [];

  final double _shippingCost = 150.0;

  List<CartModel> get cartItems => _cartItems;

  double get shippingCost => _shippingCost;

  void addToCart(GlassesModel product) {
    final index = _cartItems.indexWhere((item) => item.product.name == product.name);
    if (index >= 0) {
      _cartItems[index].incrementQuantity();
    } else {
      _cartItems.add(CartModel(
        product: product,
        quantity: 1,
        price: product.price,
      ));
    }
  }

  void removeFromCart(String productName) {
    final index = _cartItems.indexWhere((item) => item.product.name == productName);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].decrementQuantity();
      } else {
        _cartItems.removeAt(index);
      }
    }
  }

  double calculateSubtotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + item.getTotalPrice());
  }

  double calculateTax() {
    final subtotal = calculateSubtotal();
    return subtotal * 0.16;
  }

  double calculateTotal() {
    final subtotal = calculateSubtotal();
    final tax = calculateTax();
    return subtotal + tax + _shippingCost;
  }
}
