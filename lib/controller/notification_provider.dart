import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider =
    ChangeNotifierProvider<NotificationProvider>((ref) {
  return NotificationProvider();
});

class NotificationProvider extends ChangeNotifier {
  late FirebaseMessaging _firebaseMessaging;
  late String _token;

  NotificationProvider() {
    _firebaseMessaging = FirebaseMessaging.instance;

    _initializeMessaging();
  }

  void _initializeMessaging() {
    try {
      FirebaseMessaging.onBackgroundMessage(
          _onBackgroundMessage); // Registra el método para manejar mensajes en segundo plano

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _handleMessage(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleMessage(message);
      });

      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          _handleMessage(message);
        }
      });
    } catch (e) {
      print('Error al inicializar Firebase Messaging: $e');
    }
  }

  void _handleMessage(RemoteMessage message) {
    print('Mensaje recibido: ${message.notification?.body}');
    // Puedes agregar lógica adicional aquí según tus necesidades
  }

  Future<String> getToken() async {
    _token = await _firebaseMessaging.getToken() ?? "";
    return _token;
  }

  Future<void> _onBackgroundMessage(RemoteMessage message) async {
    print('Mensaje en segundo plano recibido: ${message.notification?.body}');
    // Agrega aquí tu lógica para manejar el mensaje en segundo plano
  }
}
