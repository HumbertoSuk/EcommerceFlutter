import 'package:app_lenses_commerce/models/glassesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GlassController {
  // Método para eliminar un registro de la colección 'glasses'
  Future<Map<String, dynamic>> deleteGlass(String glassId) async {
    try {
      await FirebaseFirestore.instance
          .collection('glasses')
          .doc(glassId)
          .delete();
      return {'success': true, 'message': 'Lente eliminado exitosamente'};
    } catch (error) {
      return {
        'success': false,
        'message': 'Error al eliminar el lente: $error'
      };
    }
  }

  /// Método para obtener un stream de todos los documentos de la colección 'glasses' en Firestore.
  /// Este método devuelve un Stream que emite instantáneas de consulta cada vez que
  /// se producen cambios en la colección 'glasses' en Firestore. Las instantáneas
  /// contienen los datos actuales de los documentos en la colección en el momento
  /// en que se emite el evento.
  Stream<QuerySnapshot> getGlassesStream() {
    return FirebaseFirestore.instance.collection('glasses').snapshots();
  }

  /// Método para buscar registros en la colección 'glasses' por un rango de IDs.
  /// Realiza una consulta a Firestore para buscar documentos cuyos IDs estén
  /// dentro del rango especificado por los parámetros '[start]' y '[end]'.
  /// Retorna:
  ///   Un Stream de QuerySnapshot que emite instantáneas de consulta
  Stream<QuerySnapshot> searchGlasses(String start, String end) {
    return FirebaseFirestore.instance
        .collection('glasses')
        .orderBy(FieldPath.documentId)
        .startAt([start]).endAt([end]).snapshots();
  }

  // Método para convertir un DocumentSnapshot a un objeto GlassesModel
  // Este método es utilizado para crear instancias de GlassesModel desde un DocumentSnapshot
  GlassesModel glassesModelFromDocument(DocumentSnapshot doc) {
    return GlassesModel.fromFirestore(doc);
  }

  // Método para obtener los detalles de un producto por su ID
  Future<GlassesModel?> getGlassById(String glassId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('glasses')
          .doc(glassId)
          .get();

      if (snapshot.exists) {
        return glassesModelFromDocument(snapshot);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  // Método para actualizar un registro de la colección 'glasses'
  Future<Map<String, dynamic>> updateGlasses({
    required String productId,
    required String name,
    required String description,
    required String material,
    required String type,
    required String color,
    required double price,
    required int stock,
    required int minStock,
    required int maxStock,
    required bool available,
    required String image,
    required DateTime creationDate,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('glasses')
          .doc(productId)
          .update({
        'name': name,
        'description': description,
        'material': material,
        'type': type,
        'color': color,
        'price': price,
        'stock': stock,
        'minStock': minStock,
        'maxStock': maxStock,
        'available': available,
        'image': image,
        'creationDate': creationDate,
      });

      return {
        'success': true,
        'message': 'Producto $productId actualizado exitosamente'
      };
    } catch (error) {
      return {
        'success': false,
        'message': 'Error al actualizar el producto: $error'
      };
    }
  }
}
