import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/controllers/glassesHome_controlles.dart';

class GlassesHomeProvider extends ChangeNotifier {
  final GlassesHomeController _homeController = GlassesHomeController();
  List<String> lensTypes =
      []; // Lista para almacenar los tipos de lentes disponibles
  Map<String, List<Map<String, dynamic>>> availableProductsByLensType =
      {}; // Mapa para almacenar los productos disponibles por tipo de lente

  Future<List<String>> fetchLensTypes() async {
    try {
      // Obtiene los tipos de lentes disponibles.
      lensTypes = await _homeController.getLensTypes();

      // Obtiene los productos disponibles por tipo de lente.
      availableProductsByLensType =
          await _homeController.getAvailableProductsByLensType();

      // Notifica a los listeners que los datos han sido actualizados.
      notifyListeners();

      return lensTypes; // Devuelve la lista de tipos de lentes
    } catch (e) {
      // Manejo de errores en caso de fallo al cargar los tipos de lentes.
      print('Error al cargar los tipos de lentes: $e');
      throw e;
    }
  }

  /// Método para obtener los productos disponibles para un tipo de lente dado.
  List<Map<String, dynamic>> getProductsForLensType(String type) {
    // Retorna los productos disponibles para el tipo de lente especificado, o una lista vacía si no hay productos.
    return availableProductsByLensType[type] ?? [];
  }

  Future<Map<String, dynamic>> getProductById(String productId) async {
    try {
      return await _homeController.getProductById(productId);
    } catch (error) {
      // Manejo de errores
      print('Error fetching product by ID in provider: $error');
      return {};
    }
  }
}
