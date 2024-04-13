import 'package:app_lenses_commerce/presentation/screens/ForgotPass/ForgotPassScreen.dart';
import 'package:app_lenses_commerce/presentation/screens/Login/loginScreen.dart';
import 'package:app_lenses_commerce/presentation/screens/SingUp/SingUpScreen.dart';
import 'package:app_lenses_commerce/presentation/screens/themeChanger/themeChanger.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/Home/HomeScreen.dart';

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
  )
];
