import 'package:firebase_core/firebase_core.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Error initializing Firebase: $e');
      throw e; // Relanza el error para que pueda ser manejado
    }
  }
}
