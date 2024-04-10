import 'package:app_lenses_commerce/config/routes/list_routes.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: routes,
  initialLocation: '/',
  debugLogDiagnostics: true,
);
