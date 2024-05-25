import 'package:app_lenses_commerce/models/CPModel.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  //  agregar más métodos aquí para manejar el carrito, como eliminar items, vaciar el carrito, etc.
}
