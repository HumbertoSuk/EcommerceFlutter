import 'package:app_lenses_commerce/controllers/cartController.dart';
import 'package:app_lenses_commerce/models/cartModel.dart';
import 'package:app_lenses_commerce/models/glassesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProviderProvider = ChangeNotifierProvider<CartProvider>((ref) {
  return CartProvider(ref);
});

class CartProvider extends ChangeNotifier {
  final CartController _cartController;
  CartProvider(Ref ref) : _cartController = CartController();

  List<CartModel> get cartItems => _cartController.cartItems;

  double get shippingCost => _cartController.shippingCost;

  void addToCart(GlassesModel product, int quantity) {
    _cartController.addToCart(product);
    notifyListeners();
  }

  void removeFromCart(String productName) {
    _cartController.removeFromCart(productName);
    notifyListeners();
  }

  double calculateSubtotal() {
    return _cartController.calculateSubtotal();
  }

  double calculateTax() {
    return _cartController.calculateTax();
  }

  double calculateTotal() {
    return _cartController.calculateTotal();
  }
}
