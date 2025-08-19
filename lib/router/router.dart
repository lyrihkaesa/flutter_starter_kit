import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/profile_page.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/errors/not_found_page.dart';
import '../presentation/pages/home_page.dart';
import 'router_item.dart';

part 'app_router.dart';

final goRouter = GoRouter(
  initialLocation: AppRouter.login.path,
  routes: [
    GoRoute(path: AppRouter.login.path, name: AppRouter.login.name, builder: (context, state) => const LoginPage()),
    GoRoute(
      path: AppRouter.register.path,
      name: AppRouter.register.name,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRouter.profile.path,
      name: AppRouter.profile.name,
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(path: AppRouter.home.path, name: AppRouter.home.name, builder: (context, state) => const HomePage()),
    GoRoute(
      path: AppRouter.notFound.path,
      name: AppRouter.notFound.name,
      builder: (context, state) => const NotFoundPage(),
    ),
  ],
  errorBuilder: (context, state) => const NotFoundPage(),
);
