import 'package:app_lenses_commerce/config/initializeFirebase.dart';
import 'package:app_lenses_commerce/config/routes/routers.dart';
import 'package:app_lenses_commerce/config/theme/themeApp.dart';
import 'package:app_lenses_commerce/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase/firebase_initializer.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Inicializa Firebase en el futuro
      future: _initializeFlutterFire(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (snapshot.hasError) {
          return _buildErrorScreen(context, snapshot.error.toString());
        } else {
          // inicializar firebase y luego la app principal
          final AppTheme appTheme = ref.watch(themeNotifierProvider);
          return MaterialApp.router(
            title: 'Vision +',
            debugShowCheckedModeBanner: false,
            theme: appTheme.getTheme(),
            routerConfig: appRouter,
          );
        }
      },
    );
  }

  // Inicializa Firebase
  Future<void> _initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Error initializing Firebase: $e');
      throw e; // Relanza el error para que pueda ser manejado
    }
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String errorMessage;

  const ErrorScreen({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Error: $errorMessage'), // Muestra el mensaje de error
      ),
    );
  }
}
