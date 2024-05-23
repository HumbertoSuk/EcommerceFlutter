import 'package:app_lenses_commerce/models/glassesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GlassesController {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('glasses');

  Future<Map<String, dynamic>> insertGlasses({
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
    required DateTime creationDate,
    required String imageUrl,
  }) async {
    try {
      // Obtener el próximo valor del contador para el nombre del documento
      int nextValue = await getNextDocumentCounter();

      // Construir el nombre del documento personalizado y autoincrementable
      String documentName = 'glasses_$nextValue';

      // Convertir el objeto DateTime a Timestamp
      Timestamp timestamp = Timestamp.fromDate(creationDate);

      // Crear una instancia de GlassesModel con los datos recibidos
      GlassesModel glasses = GlassesModel(
        name: name,
        description: description,
        material: material,
        type: type,
        color: color,
        price: price,
        stock: stock,
        minStock: minStock,
        maxStock: maxStock,
        available: available,
        creationDate: timestamp, // Pasar el Timestamp en lugar de DateTime
        image: imageUrl,
      );

      // Agregar las gafas a la colección 'glasses' en Firestore con el nombre de documento personalizado
      await _collectionReference.doc(documentName).set(glasses.toMap());

      // Devolver un mensaje de éxito
      return {
        'success': true,
        'message': '¡Los datos de los lentes se han insertado correctamente!'
      };
    } catch (error) {
      // En caso de error, devolver un mensaje de error
      return {
        'success': false,
        'message': 'Error al insertar los datos de las gafas: $error'
      };
    }
  }

  // Método para obtener el próximo valor del contador para el nombre del documento
  Future<int> getNextDocumentCounter() async {
    // Obtener una referencia al documento del contador
    DocumentReference counterRef = FirebaseFirestore.instance
        .collection('counters')
        .doc('documentCounter');

    // Obtener el valor actual del contador
    DocumentSnapshot snapshot = await counterRef.get();
    int currentValue = snapshot.exists ? snapshot['AutoIncremet'] ?? 0 : 0;

    // Incrementar el valor del contador
    int nextValue = currentValue + 1;

    // Actualizar el valor del contador en la base de datos
    await counterRef.set({'AutoIncremet': nextValue});

    // Retornar el próximo valor del contador
    return nextValue;
  }
}
