import 'package:app_lenses_commerce/controllers/editDeleteGlassesController.dart';
import 'package:app_lenses_commerce/models/glassesModel.dart';
import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/controllers/glassesAddController.dart';
import 'package:app_lenses_commerce/presentation/providers/snackbarMessage_Provider.dart';

class ProductProvider extends ChangeNotifier {
  final SnackbarProvider snackbarProvider;

  ProductProvider({
    required this.snackbarProvider,
  });

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
    final glassesController = GlassesController();
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
      if (result['success']) {
        snackbarProvider.showSnackbar(context, result['message']);
      } else {
        snackbarProvider.showSnackbar(context, result['message']);
      }
    }).catchError((error) {
      snackbarProvider.showSnackbar(context, 'Error: $error');
    });
  }

  Future<void> updateProduct({
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
    required BuildContext context,
  }) async {
    final glassController = GlassController();
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

    if (result['success']) {
      snackbarProvider.showSnackbar(context, result['message']);
    } else {
      snackbarProvider.showSnackbar(context, result['message']);
    }
  }

  Future<GlassesModel?> getProductDetails(context, String productId) async {
    try {
      final glassController = GlassController();
      return await glassController.getGlassById(productId);
    } catch (e) {
      snackbarProvider.showSnackbar(
          context, 'Error cargando los detalles del producto: $e');
      return null;
    }
  }
}
