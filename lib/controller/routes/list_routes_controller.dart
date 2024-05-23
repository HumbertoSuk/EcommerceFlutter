import 'package:app_lenses_commerce/presentation/screens/Edit-Delet/EditDeleteScreen.dart';
import 'package:app_lenses_commerce/presentation/screens/EditGlasses/EditGlassesScreen.dart';
import 'package:app_lenses_commerce/presentation/screens/ForgotPass/ForgotPassScreen.dart';
import 'package:app_lenses_commerce/presentation/screens/Home/HomeScreen.dart';
import 'package:app_lenses_commerce/presentation/screens/Login/loginScreen.dart';
import 'package:app_lenses_commerce/presentation/screens/RegisterNewGlasses/RegisterGlassesScreen.dart';
import 'package:app_lenses_commerce/presentation/screens/SettingsScreen/SettingsScreen.dart';
import 'package:app_lenses_commerce/presentation/screens/SingUp/SingUpScreen.dart';
import 'package:app_lenses_commerce/presentation/screens/detail-Glasses/DetailGlassesScreen.dart';
import 'package:app_lenses_commerce/presentation/screens/themeChanger/themeChanger.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> routes = [
  GoRoute(
    path: '/',
    name: LoginScreen.nameScreen,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/theme-changer',
    name: ThemeChangeScreen.nameScreen,
    builder: (context, state) => const ThemeChangeScreen(),
  ),
  GoRoute(
    path: '/Home',
    name: HomeScreen.nameScreen,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/SignUp',
    name: RegisterScreen.nameScreen,
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
    path: '/ForgotPasswordScreen',
    name: ForgotPasswordScreen.nameScreen,
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
  GoRoute(
    path: '/Settings',
    name: SettingsScreen.nameScreen,
    builder: (context, state) => const SettingsScreen(),
  ),
  GoRoute(
    path: '/add-lenses',
    name: RegisterGlassesScreen.nameScreen,
    builder: (context, state) => const RegisterGlassesScreen(),
  ),
  GoRoute(
    path: '/edit-delete-lenses',
    name: EditDeleteScreen.nameScreen,
    builder: (context, state) => const EditDeleteScreen(),
  ),
  GoRoute(
    path: '/editExist-lenses',
    name: EditGlassesScreen.nameScreen,
    builder: (context, state) {
      final glassId = state.uri.queryParameters['id'] ?? '';
      return EditGlassesScreen(glassId: glassId);
    },
  ),
  GoRoute(
    path: '/detail-glasses',
    name: DetailScreen.nameScreen,
    builder: (context, state) {
      final productId = state.uri.queryParameters['productId'] ?? '';
      return DetailScreen(productId: productId);
    },
  ),
];
