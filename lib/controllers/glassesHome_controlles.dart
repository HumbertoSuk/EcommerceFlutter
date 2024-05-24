import 'package:app_lenses_commerce/models/glassesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GlassesHomeController {
  Future<List<String>> getLensTypes() async {
    try {
      // Consulta la colección 'glasses' en Firestore.
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('glasses').get();

      // Extrae los tipos de lentes de los documentos obtenidos.
      final List<String> lensTypes = querySnapshot.docs
          .map((doc) => doc.get('type') as String)
          .toSet()
          .toList();

      // Devuelve la lista de tipos de lentes.
      return lensTypes;
    } catch (error) {
      // Manejo de errores en caso de fallo al obtener los tipos de lentes.
      print('Error fetching lens types: $error');
      return [];
    }
  }

  // Nuevo método para obtener los productos utilizando el modelo GlassesModel
  Future<Map<String, List<Map<String, dynamic>>>>
      getAvailableProductsByLensType() async {
    try {
      // Consulta la colección 'glasses' en Firestore donde 'available' es igual a true.
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('glasses')
          .where('available', isEqualTo: true)
          .get();

      // Mapa para almacenar los productos disponibles por tipo de lente.
      final Map<String, List<Map<String, dynamic>>> productsByLensType = {};

      // Itera sobre los documentos obtenidos en la consulta.
      for (final doc in querySnapshot.docs) {
        // Crea una instancia de GlassesModel utilizando el método fromFirestore.
        final model = GlassesModel.fromFirestore(doc);

        // Obtiene el tipo de lente del modelo.
        final type = model.type;

        // Convierte el modelo en un mapa utilizando el método toMap.
        final data = model.toMap();

        // Verifica si ya existe una lista de productos para este tipo de lente.
        if (!productsByLensType.containsKey(type)) {
          productsByLensType[type] = [];
        }

        // Agrega el ID del producto al mapa de datos.
        data['productId'] = doc.id;

        // Agrega los datos del producto a la lista correspondiente al tipo de lente.
        productsByLensType[type]!.add(data);
      }

      // Devuelve el mapa de productos por tipo de lente.
      return productsByLensType;
    } catch (error) {
      // Manejo de errores en caso de fallo al obtener los productos utilizando el modelo.
      print('Error fetching available products using model: $error');
      return {};
    }
  }

  Future<Map<String, dynamic>> getProductById(String productId) async {
    try {
      // Consulta el documento en Firestore utilizando el ID del producto.
      final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('glasses')
          .doc(productId)
          .get();

      // Verifica si el documento existe.
      if (docSnapshot.exists) {
        // Crea una instancia de GlassesModel utilizando el método fromFirestore.
        final model = GlassesModel.fromFirestore(docSnapshot);

        // Convierte el modelo en un mapa utilizando el método toMap.
        final data = model.toMap();

        // Agrega el ID del producto al mapa de datos.
        data['productId'] = docSnapshot.id;

        // Devuelve el mapa de datos del producto.
        return data;
      } else {
        // Si el documento no existe, devuelve un mapa vacío.
        return {};
      }
    } catch (error) {
      // Manejo de errores
      print('Error fetching product by ID: $error');
      return {};
    }
  }
  /*
  Future<void> addToCart(String productId, int quantity) async {
  try {
    // Consulta el documento en Firestore utilizando el ID del producto.
    final DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('glasses')
        .doc(productId)
        .get();

    // Verifica si el documento existe.
    if (docSnapshot.exists) {
      // Obtiene el stock actual del producto.
      final int currentStock = docSnapshot.get('stock');

      // Verifica si hay suficiente stock para agregar al carrito.
      if (currentStock >= quantity) {
        // Agrega el producto al carrito en Firestore (implementar esta parte según la estructura de tu base de datos).
        // Por ejemplo, puedes tener una colección 'cart' donde cada documento representa un usuario y contiene los productos en su carrito.
        // Aquí, puedes agregar lógica para actualizar el carrito del usuario con el nuevo producto y la cantidad.
        
        // Por ejemplo:
        // await FirebaseFirestore.instance.collection('cart').doc(userId).set({
        //   'productId': productId,
        //   'quantity': quantity,
        // }, SetOptions(merge: true));

        print('Producto agregado al carrito.');
      } else {
        print('No hay suficiente stock para agregar al carrito.');
      }
    } else {
      print('El producto no existe.');
    }
  } catch (error) {
    // Manejo de errores
    print('Error al agregar producto al carrito: $error');
  }
}
*/

}
