import 'package:app_lenses_commerce/screens/ForgotPass/ForgotPassScreen.dart';
import 'package:app_lenses_commerce/screens/Home/homeScreen.dart';
import 'package:app_lenses_commerce/screens/Login/loginScreen.dart';
import 'package:app_lenses_commerce/screens/SingUp/SingUpScreen.dart';
import 'package:app_lenses_commerce/screens/themeChanger/themeChanger.dart';
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
  )
];
