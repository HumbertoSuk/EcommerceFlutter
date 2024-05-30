import 'package:app_lenses_commerce/config/auth.dart';
import 'package:app_lenses_commerce/models/cartModel.dart';
import 'package:app_lenses_commerce/models/glassesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartController {
  final FirebaseAuth _auth = AuthService.authInstance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection('carts');

  // Agrega un artículo al carrito
  Future<void> addToCart(CartItem item) async {
    final String userId = _auth.currentUser!.uid;
    final docRef =
        _cartCollection.doc(userId).collection('items').doc(item.productId);
    final existingDoc = await docRef.get();

    if (existingDoc.exists) {
      await docRef.update({
        'quantity': (existingDoc['quantity'] ?? 0) + item.quantity,
      });
    } else {
      await docRef.set(item.toMap());
    }
  }

  // Actualiza un artículo en el carrito
  Future<void> updateCartItem(CartItem item) async {
    final String userId = _auth.currentUser!.uid;
    final docRef =
        _cartCollection.doc(userId).collection('items').doc(item.productId);
    await docRef.update(item.toMap());
  }

  // Obtiene una instantánea de los elementos del carrito
  Future<QuerySnapshot<Map<String, dynamic>>> getCartItemsSnapshot() async {
    final String userId = _auth.currentUser!.uid;
    final QuerySnapshot<Map<String, dynamic>> cartItemsSnapshot =
        await _firestore
            .collection('carts')
            .doc(userId)
            .collection('items')
            .get();

    return cartItemsSnapshot;
  }

  // Elimina un artículo del carrito
  Future<void> removeFromCart(String productId) async {
    final String userId = _auth.currentUser!.uid;
    final docRef =
        _cartCollection.doc(userId).collection('items').doc(productId);
    await docRef.delete();
  }

  // Vacía el carrito
  Future<void> clearCart() async {
    final String userId = _auth.currentUser!.uid;
    final QuerySnapshot<Map<String, dynamic>> cartItemsSnapshot =
        await _firestore
            .collection('carts')
            .doc(userId)
            .collection('items')
            .get();

    for (final doc in cartItemsSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Obtiene un stream de los elementos del carrito
  Stream<List<CartItem>> getCartItemsStream() {
    final String userId = _auth.currentUser!.uid;
    return _cartCollection.doc(userId).collection('items').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => CartItem.fromFirestore(doc)).toList());
  }

  // Verifica si el carrito existe
  Future<bool> doesCartExist() async {
    final String userId = _auth.currentUser!.uid;
    final docSnapshot = await _cartCollection.doc(userId).get();
    return docSnapshot.exists;
  }

  // Crea un carrito
  Future<void> createCart() async {
    final String userId = _auth.currentUser!.uid;
    await _cartCollection.doc(userId).set(<String, dynamic>{});
  }

  // Obtiene un producto por su ID y lo mapea
  Future<Map<String, dynamic>> getProductByIdMapper(String productId) async {
    try {
      final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('glasses')
          .doc(productId)
          .get();

      if (docSnapshot.exists) {
        final model = GlassesModel.fromFirestore(docSnapshot);
        final data = model.toMap();
        data['productId'] = docSnapshot.id;
        return data;
      } else {
        return {};
      }
    } catch (error) {
      return {};
    }
  }

  // Procesa la compra
  Future<Map<String, dynamic>> processPurchase(List<CartItem> cartItems,
      double subtotal, double tax, double shipping, double total) async {
    final String userId = _auth.currentUser!.uid;
    final String userEmail = _auth.currentUser!.email!;
    //Para hacer un procedure
    final WriteBatch batch = _firestore.batch();

    // Verifica si hay suficiente stock para cada producto
    for (CartItem item in cartItems) {
      final DocumentSnapshot productSnapshot =
          await _firestore.collection('glasses').doc(item.productId).get();
      if (productSnapshot.exists) {
        final int stock = productSnapshot['stock'] ?? 0;
        if (stock < item.quantity) {
          return {
            'success': false,
            'message':
                'No hay suficiente stock para el producto ${item.productName}',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Producto ${item.productName} no encontrado',
        };
      }
    }

    // Descontar el stock
    for (CartItem item in cartItems) {
      final DocumentReference productRef =
          _firestore.collection('glasses').doc(item.productId);
      batch.update(productRef, {
        'stock': FieldValue.increment(-item.quantity),
      });
    }

    // Insertar en la colección tickets
    final DocumentReference ticketRef = _firestore.collection('tickets').doc();
    batch.set(ticketRef, {
      'userId': userId,
      'userEmail': userEmail,
      'cartItems': cartItems.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'iva': tax,
      'envio': shipping,
      'total': total,
      'timestamp': FieldValue.serverTimestamp(),
    });

    try {
      await batch.commit();
      // Vaciar el carrito después de la compra
      await clearCart();
      return {
        'success': true,
        'message': 'Compra completada con éxito',
      };
    } catch (error) {
      return {
        'success': false,
        'message': 'Error al procesar la compra: $error',
      };
    }
  }
}
