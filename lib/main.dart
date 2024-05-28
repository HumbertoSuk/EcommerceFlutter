import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lenses_commerce/config/initializeFirebase.dart';
import 'package:app_lenses_commerce/config/routes/routers.dart';
import 'package:app_lenses_commerce/config/theme/themeApp.dart';
import 'package:app_lenses_commerce/presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseInitializer.initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (snapshot.hasError) {
          return _buildErrorScreen(context, snapshot.error.toString());
        } else {
          return _buildApp();
        }
      },
    );
  }

// beh
  Widget _buildApp() {
    return Consumer(
      builder: (context, ref, child) {
        final AppTheme appTheme = ref.watch(themeNotifierProvider);
        return MaterialApp.router(
          title: 'Vision +',
          debugShowCheckedModeBanner: false,
          theme: appTheme.getTheme(),
          routerConfig: appRouter,
        );
      },
    );
  }

  Widget _buildErrorScreen(BuildContext context, String errorMessage) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ErrorScreen(errorMessage: errorMessage),
    );
  }
}

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
