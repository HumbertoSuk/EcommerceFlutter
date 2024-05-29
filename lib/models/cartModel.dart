import 'glassesModel.dart';

class CartModel {
  int quantity;
  double price;
  GlassesModel product;

  CartModel({
    required this.quantity,
    required this.price,
    required this.product,
  });

  // Método para incrementar la cantidad del producto en el carrito
  void incrementQuantity() {
    quantity += 1;
  }

  // Método para decrementar la cantidad del producto en el carrito
  void decrementQuantity() {
    if (quantity > 1) {
      quantity -= 1;
    }
  }

  // Método para calcular el precio total de este producto en el carrito
  double getTotalPrice() {
    return price * quantity;
  }
}
