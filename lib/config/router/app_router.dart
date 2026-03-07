import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/features/auth/screens/screens.dart';

/// Central place to define route names.
class RouteNames {
  static const String login = '/';
  static const String register = '/register';
  static const String dashboardAdmin = '/dashboard_admin';
}

/// Simple router you can later extend with route protection.
class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case RouteNames.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case RouteNames.dashboardAdmin:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      default:
        // Fallback route
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
          settings: settings,
        );
    }
  }
}
