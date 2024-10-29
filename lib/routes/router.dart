import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management/pages/home_page.dart';
import 'package:task_management/pages/error_page.dart';
import 'package:task_management/pages/login_page.dart';
final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser == null && state.uri.toString() != '/login') {
      return '/login';
    }
    return null;
  },
  errorBuilder: (context, state) => const ErrorPage(),
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const TaskHomePage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
