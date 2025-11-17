part of 'router.dart';

class AppRouter {
  // Auth Routes
  static const login = RouteItem(name: 'login', path: '/login');
  static const register = RouteItem(name: 'register', path: '/register');

  // Main Routes
  static const home = RouteItem(name: 'home', path: '/home');
  static const profile = RouteItem(name: 'profile', path: '/profile');

  // Admin Panel
  static const adminPanel = RouteItem(name: 'admin_panel', path: '/admin');

  // Error Routes
  static const notFound = RouteItem(name: 'not_found', path: '/not_found');

  // Private constructor
  AppRouter._();
}
