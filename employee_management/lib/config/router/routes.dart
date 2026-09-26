import 'package:employee_management/modules/authentication/presentation/bloc/auth_bloc.dart';
import 'package:employee_management/modules/authentication/presentation/router/auth_router_notifier.dart';
import 'package:employee_management/modules/authentication/presentation/view/forgot_password_screen.dart';
import 'package:employee_management/modules/authentication/presentation/view/login_screen.dart';
import 'package:employee_management/modules/authentication/presentation/view/signup_screen.dart';
import 'package:employee_management/modules/employee_dashboard/presentation/employee_dashboard_screen.dart';
import 'package:employee_management/utils/injectible.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class MyAppRouter {
  final GoRouter router;

  MyAppRouter() : router = _createRouter();

  static GoRouter _createRouter() {
    final authBloc = serviceLocator<AuthBloc>();

    final authNotifier = AuthRouterNotifier(authBloc);

    return GoRouter(
      initialLocation: '/login',

      navigatorKey: rootNavigatorKey,

      refreshListenable: authNotifier,

      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) {
            return const LoginScreen();
          },
        ),

        GoRoute(
          path: '/signup',
          builder: (context, state) {
            return const SignupScreen();
          },
        ),

        GoRoute(
          path: '/forgot-password',
          builder: (context, state) {
            return const ForgotPasswordScreen();
          },
        ),

        GoRoute(
          path: '/',
          builder: (context, state) {
            return const EmployeeDashboardScreen();
          },
        ),
      ],

      redirect: (context, state) {
        final authState = authBloc.state;

        final bool isLoggedIn = authState is Authenticated;

        final bool isAuthRoute =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/signup' ||
            state.matchedLocation == '/forgot-password';

        if (authState is AuthInitial || authState is AuthLoading) {
          return null;
        }

        if (!isLoggedIn && !isAuthRoute) {
          return '/login';
        }

        if (isLoggedIn && isAuthRoute) {
          return '/';
        }

        return null;
      },
    );
  }
}
