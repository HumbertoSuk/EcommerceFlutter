import 'package:app_lenses_commerce/config/initializeFirebase.dart';
import 'package:app_lenses_commerce/config/routes/routers.dart';
import 'package:app_lenses_commerce/config/theme/themeApp.dart';
import 'package:app_lenses_commerce/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializa Firebase
    return FutureBuilder(
      future: FirebaseInitializer.initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (snapshot.hasError) {
          return _buildErrorScreen(snapshot.error.toString());
        } else {
          return _buildApp();
        }
      },
    );
  }

  Widget _buildApp() {
    return Consumer(builder: (context, ref, child) {
      final AppTheme appTheme = ref.watch(themeNotifierProvider);
      return MaterialApp.router(
        title: 'Vision +',
        debugShowCheckedModeBanner: false,
        theme: appTheme.getTheme(),
        routerConfig: appRouter,
      );
    });
  }

  Widget _buildErrorScreen(String errorMessage) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ErrorScreen(errorMessage: errorMessage),
    );
  }
}

// SplashScreen que se muestra durante la inicialización de Firebase
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

// ErrorScreen que se muestra cuando hay un error durante la inicialización de Firebase
class ErrorScreen extends StatelessWidget {
  final String errorMessage;

  const ErrorScreen({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Error: $errorMessage'),
      ),
    );
  }
}
