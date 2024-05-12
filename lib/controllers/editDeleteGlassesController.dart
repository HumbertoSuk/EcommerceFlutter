import 'package:app_lenses_commerce/models/glassesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GlassController {
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

  Stream<QuerySnapshot> getGlassesStream() {
    return FirebaseFirestore.instance.collection('glasses').snapshots();
  }

  Stream<QuerySnapshot> searchGlasses(String start, String end) {
    return FirebaseFirestore.instance
        .collection('glasses')
        .orderBy(FieldPath.documentId)
        .startAt([start]).endAt([end]).snapshots();
  }

  // Método para convertir un DocumentSnapshot a un objeto GlassesModel
  GlassesModel glassesModelFromDocument(DocumentSnapshot doc) {
    return GlassesModel.fromFirestore(doc);
  }

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
      print('Error al obtener los datos del lente: $error');
      return null;
    }
  }

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

      return {'success': true, 'message': 'Producto actualizado exitosamente'};
    } catch (error) {
      return {
        'success': false,
        'message': 'Error al actualizar el producto: $error'
      };
    }
  }
}
