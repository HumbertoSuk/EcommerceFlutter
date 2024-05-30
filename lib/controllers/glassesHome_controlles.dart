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

      return {};
    }
  }
}
