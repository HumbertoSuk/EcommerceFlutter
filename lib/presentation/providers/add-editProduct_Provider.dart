import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/controllers/editDeleteGlassesController.dart';
import 'package:app_lenses_commerce/controllers/glassesAddController.dart';
import 'package:app_lenses_commerce/models/glassesModel.dart';
import 'package:app_lenses_commerce/presentation/providers/snackbarMessage_Provider.dart';

class ProductProvider extends ChangeNotifier {
  final SnackbarProvider snackbarProvider;

  // Constructor que inicializa el proveedor con un SnackbarProvider Message
  ProductProvider({
    required this.snackbarProvider,
  });

  // Método para agregar un nuevo producto
  void addNewProduct({
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
    required String imageUrl,
    required DateTime creationDate,
    required BuildContext context,
  }) {
    // Se instancia el controlador de gafas
    final glassesController = GlassesController();

    // Se llama al método para insertar una nuevos lentes
    glassesController
        .insertGlasses(
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
      creationDate: creationDate,
      imageUrl: imageUrl,
    )
        .then((result) {
      // Se muestra un Snackbar con el resultado de la operación
      snackbarProvider.showSnackbar(context, result['message']);
    }).catchError((error) {
      // En caso de error, se muestra un Snackbar con el mensaje de error
      snackbarProvider.showSnackbar(context, 'Error: $error');
    });
  }

  // Método para actualizar un producto existente
  void updateProduct({
    required BuildContext context,
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
      // Se instancia el controlador
      final glassController = GlassController();

      // Se llama al método para actualizar del controlador para firebase
      final result = await glassController.updateGlasses(
        productId: productId,
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
        creationDate: creationDate,
        image: image,
      );

      // Se muestra un Snackbar con el resultado de la operación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    } catch (error) {
      // Manejar errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  // Método para obtener los articulos de mi BD de firestore
  // se maneja como Future porque es una llamada asincrona a firebase
  Future<GlassesModel?> getProductDetails(
      BuildContext context, String productId) async {
    try {
      // Se instancia el controlador de gafas
      final glassController = GlassController();

      // Se obtienen los detalles de la gafa por su ID
      return await glassController.getGlassById(productId);
    } catch (e) {
      // En caso de error, se muestra un Snackbar con el mensaje de error
      snackbarProvider.showSnackbar(
          context, 'Error cargando los detalles del producto: $e');
      return null;
    }
  }

  // Método para eliminar un producto
  Future<String> deleteProduct({
    required BuildContext context,
    required String productId,
  }) async {
    try {
      // Se instancia el controlador
      final glassController = GlassController();

      // Llamar al método para eliminar del controlador para firebase
      final result = await glassController.deleteGlass(productId);

      // Devolver el resultado como mensaje
      return result['message'];
    } catch (error) {
      // Manejar errores y devolver el mensaje de error
      return 'Error: $error';
    }
  }
}
