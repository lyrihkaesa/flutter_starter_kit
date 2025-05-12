part of 'router.dart';

class AppRouter {
  // Auth Routes
  static const login = RouteItem(name: 'login', path: '/login');

  static const home = RouteItem(name: 'home', path: '/home');

  // Not Found Route
  static const notFound = RouteItem(name: 'not_found', path: '/not_found');

  // Private constructor
  AppRouter._();
}
