import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/features/auth/presentation/screens/screens.dart';
import 'package:sap_automotriz_app/features/customers/presentation/screens/customers_screen.dart';
import 'package:sap_automotriz_app/features/dashboard/presentation/screens/dashboard_admin_screen.dart';
import 'package:sap_automotriz_app/features/service_labor/presentation/screens/labor_catalog_screen.dart';
import 'package:sap_automotriz_app/features/services/presentation/screens/services_hub_screen.dart';
import 'package:sap_automotriz_app/features/users/presentation/screens/user_account_screen.dart';

class RouteNames {
  static const String login = '/';
  static const String register = '/register';
  static const String dashboardAdmin = '/dashboard_admin';
  static const String customers = '/customers';
  static const String laborCatalog = '/labor_catalog';
  static const String userAccounts = '/user_accounts';
  static const String services = '/services';
}

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
          builder: (_) => const DashboardAdminScreen(),
          settings: settings,
        );

      case RouteNames.customers:
        return MaterialPageRoute(
          builder: (_) => const CustomersScreen(),
          settings: settings,
        );
      case RouteNames.laborCatalog:
        return MaterialPageRoute(
          builder: (_) => const LaborCatalogScreen(),
          settings: settings,
        );
      case RouteNames.userAccounts:
        return MaterialPageRoute(
          builder: (_) => const UserAccountScreen(),
          settings: settings,
        );
      case RouteNames.services:
        return MaterialPageRoute(
          builder: (_) => const ServicesHubScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
          settings: settings,
        );
    }
  }
}
