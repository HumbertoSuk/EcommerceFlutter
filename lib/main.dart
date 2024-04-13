import 'package:app_lenses_commerce/config/routes/routers.dart';
import 'package:app_lenses_commerce/config/theme/themeApp.dart';
import 'package:app_lenses_commerce/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFlutterFire(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSplashScreen();
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

  Widget _buildSplashScreen() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }

  Widget _buildErrorScreen(String errorMessage) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ErrorScreen(errorMessage: errorMessage),
    );
  }

  Future<void> _initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Error initializing Firebase: $e');
      throw e;
    }
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
        child: Text('Error: $errorMessage'),
      ),
    );
  }
}
