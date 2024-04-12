import 'package:app_lenses_commerce/controller/routes/routers_controller.dart';
import 'package:app_lenses_commerce/views/ErrorScreen/error_screen.dart';
import 'package:app_lenses_commerce/views/SplashScreen/splash_screen.dart';
import 'package:app_lenses_commerce/views/themeApp/themeApp.dart';
import 'package:flutter/material.dart';
import 'package:app_lenses_commerce/config/routes/routers.dart';
import 'package:app_lenses_commerce/config/theme/themeApp.dart';
import 'package:app_lenses_commerce/presentation/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase/firebase_initializer.dart';

class MainApp extends ConsumerWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      // Inicializa Firebase en el futuro
      future: FirebaseInitializer.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ErrorScreen(errorMessage: snapshot.error.toString()),
          );
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
}
