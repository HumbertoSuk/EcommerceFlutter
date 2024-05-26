import 'dart:async';
import 'dart:io';
import 'package:app_lenses_commerce/models/push_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/presentation/providers/snackbarMessage_Provider.dart';

class NotificationProvider {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final StreamController<PushMessage> mensaggesPushNotification =
      StreamController<PushMessage>.broadcast();
  final SnackbarProvider _snackbarProvider;
  final BuildContext context; // Agrega el contexto aquí

  NotificationProvider(this.context, this._snackbarProvider) {
    initNotification();
  }

  void initNotification() async {
    await _messaging.requestPermission();
    final token = await _messaging.getToken();
    print("Token FCM actual: $token");

    // Configura los manejadores de mensajes
    FirebaseMessaging.onMessage.listen(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleLaunch);
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  void handleMessage(RemoteMessage message) {
    final notificationData = message.notification;
    if (notificationData != null) {
      final title = notificationData.title ?? '';
      final body = notificationData.body ?? '';
      final imageUrl = _getImageUrl(message);
      final data = message.data;

      print("Notificación recibida:");
      print("Título: $title");
      print("Cuerpo: $body");
      print("Datos: $data");
      if (imageUrl != null) {
        print("URL de la imagen: $imageUrl");
      }

      // Verificar si el StreamController está cerrado antes de agregar un evento
      if (!mensaggesPushNotification.isClosed) {
        // Convierte la notificación en un objeto PushMessage
        final pushMessage = PushMessage(
          messageId: message.messageId ?? '',
          title: title,
          body: body,
          sentDate: DateTime.now(),
          image: imageUrl,
          data: data,
        );

        // Agrega la notificación al stream
        mensaggesPushNotification.add(pushMessage);

        // Mostrar la notificación como un Snackbar
        _showSnackbarWithNotification(title, body);

        // Redirige a otra página si es necesario
      } else {
        print("El StreamController está cerrado, no se puede agregar eventos.");
      }
    }
  }

  void handleLaunch(RemoteMessage message) {
    handleMessage(message);
  }

  String? _getImageUrl(RemoteMessage message) {
    final notificationData = message.notification;
    if (notificationData != null) {
      if (Platform.isAndroid) {
        return notificationData.android?.imageUrl;
      } else if (Platform.isIOS) {
        return notificationData.apple?.imageUrl;
      }
    }
    return null;
  }

  void _showSnackbarWithNotification(String title, String body) {
    _snackbarProvider.showCustomSnackbar(context, title, body);
  }

  Map<String, dynamic>? getNotificationData(RemoteMessage message) {
    final notificationData = message.notification;
    if (notificationData != null) {
      final data = message.data;
      return {
        'title': notificationData.title ?? '',
        'body': notificationData.body ?? '',
        'imageUrl': _getImageUrl(message),
        'data': data,
      };
    }
    return null;
  }

  void dispose() {
    mensaggesPushNotification.close(); // Cierra el stream controller
  }
}
