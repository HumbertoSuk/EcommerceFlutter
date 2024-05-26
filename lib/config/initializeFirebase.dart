import 'package:app_lenses_commerce/presentation/providers/notification_provider.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseInitializer {
  /// Inicializa Firebase y maneja cualquier error que pueda ocurrir durante la inicialización.
  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      // Maneja cualquier error que ocurra durante la inicialización de Firebase
      rethrow;
    }
  }
}
