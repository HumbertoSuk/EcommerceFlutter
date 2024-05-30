import 'package:app_lenses_commerce/controllers/cartController.dart';
import 'package:app_lenses_commerce/models/cartModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProviderProvider = ChangeNotifierProvider<CartProvider>((ref) {
  return CartProvider();
});

class CartProvider extends ChangeNotifier {
  final CartController _cartController = CartController();

  final List<CartItem> _cartItems = [];
  final double _shippingCost = 150.0;

  List<CartItem> get cartItems => _cartItems;
  double get shippingCost => _shippingCost;

  // Propiedades para cargar la información del producto
  bool isLoading = false;
  Map<String, dynamic> productData = {};

  CartProvider() {
    // Cargar el carrito del usuario actual al iniciar
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    // Verificar si el usuario tiene un carrito existente
    final cartExists = await _cartController.doesCartExist();
    if (!cartExists) {
      await _cartController.createCart(); // Crear un nuevo carrito si no existe
    }

    // Cargamos los datos del carrito desde Firestore para el usuario actual
    final cartItemsSnapshot = await _cartController.getCartItemsSnapshot();
    _cartItems.clear();
    for (final doc in cartItemsSnapshot.docs) {
      final cartItem = CartItem.fromFirestore(doc);
      _cartItems.add(cartItem);
    }

    notifyListeners();
  }

  Future<void> addToCart(String productId) async {
    final productData = await _cartController.getProductByIdMapper(productId);
    final int maxStock = productData['stock'] ?? 0;

    final existingItemIndex =
        _cartItems.indexWhere((item) => item.productId == productId);

    if (existingItemIndex != -1) {
      // Si el artículo ya está en el carrito, solo incrementa la cantidad localmente
      final existingItem = _cartItems[existingItemIndex];
      if (existingItem.quantity < maxStock) {
        // Incrementar la cantidad en 1
        _cartItems[existingItemIndex] =
            existingItem.copyWith(quantity: existingItem.quantity + 1);
        // Actualizar la cantidad en Firestore
        await _cartController.updateCartItem(_cartItems[existingItemIndex]);
      }
    } else {
      // Si el artículo no está en el carrito, añádelo con cantidad 1
      if (_cartItems.length < maxStock) {
        final defaultItem = CartItem(
          productId: productId,
          productName: productData['name'], // Nombre del producto
          price: productData['price'], // Precio del producto
          image: productData['image'], // Imagen del producto
          quantity: 1,
        );
        _cartItems.add(defaultItem);
        // Actualizar la cantidad en Firestore
        await _cartController.addToCart(defaultItem);
      }
    }

    // Recargar los datos del carrito después de cada modificación
    await _loadCartItems();
  }

  Future<void> removeFromCart(String productId) async {
    final existingItemIndex =
        _cartItems.indexWhere((item) => item.productId == productId);

    if (existingItemIndex != -1) {
      // Si el artículo está en el carrito, solo decrementa la cantidad localmente
      final existingItem = _cartItems[existingItemIndex];
      if (existingItem.quantity > 1) {
        // Disminuir la cantidad en 1
        _cartItems[existingItemIndex] =
            existingItem.copyWith(quantity: existingItem.quantity - 1);
        // Actualizar la cantidad en Firestore
        await _cartController.updateCartItem(_cartItems[existingItemIndex]);
      } else {
        // Eliminar el artículo del carrito
        await _cartController.removeFromCart(productId);
      }
    }

    // Recargamos los datos del carrito después de cada modificación
    await _loadCartItems();
  }

  double calculateSubtotal() {
    return _cartItems.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));
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

  // Método para obtener la información del producto por su ID
  Future<void> getProductById(String productId) async {
    isLoading = false;
    try {
      productData = await _cartController.getProductByIdMapper(productId);

      isLoading = true;
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> init() async {
    await _loadCartItems();
  }

  Future<void> removeItemFromCart(String productId) async {
    await _cartController.removeFromCart(productId);
  }

  Future<Map<String, dynamic>> processPurchase() async {
    final subtotal = calculateSubtotal();
    final tax = calculateTax();
    final shipping = _shippingCost;
    final total = calculateTotal();

    return await _cartController.processPurchase(
      _cartItems,
      subtotal,
      tax,
      shipping,
      total,
    );
  }

  clearCartUser() async {
    return await _cartController.clearCart();
  }
}
