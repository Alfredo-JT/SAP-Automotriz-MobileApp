import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/features/auth/presentation/screens/screens.dart';
import 'package:sap_automotriz_app/features/admin/customers/presentation/screens/customers_screen.dart';
import 'package:sap_automotriz_app/features/admin/shared/presentation/screens/admin_dashboard.dart';
import 'package:sap_automotriz_app/features/admin/service_labor/presentation/screens/labor_catalog_screen.dart';
import 'package:sap_automotriz_app/features/admin/services/presentation/screens/services_hub_screen.dart';
import 'package:sap_automotriz_app/features/users/presentation/screens/user_account_screen.dart';
import 'package:sap_automotriz_app/features/workshop_manager/services/presentation/screens/wm_authorized_screen.dart';
import 'package:sap_automotriz_app/features/workshop_manager/services/presentation/screens/wm_completed_screen.dart';
import 'package:sap_automotriz_app/features/workshop_manager/services/presentation/screens/wm_reviewed_screen.dart';
import 'package:sap_automotriz_app/features/workshop_manager/services/presentation/screens/wm_unquoted_screen.dart';
import 'package:sap_automotriz_app/features/workshop_manager/services/presentation/screens/workload_screen.dart';
import 'package:sap_automotriz_app/features/workshop_manager/shared/presentation/screens/workshop_manager_dashboard.dart';

class RouteNames {
  static const String login = '/';
  static const String register = '/register';

  // Admin routes
  static const String dashboardAdmin = '/dashboard_admin';
  static const String customers = '/dashboard_admin/customers';
  static const String laborCatalog = '/dashboard_admin/labor_catalog';
  static const String userAccounts = '/dashboard_admin/user_accounts';
  static const String services = '/dashboard_admin/services';

  // Workshop manager routes
  static const String dashboardWm = '/dashboard_wm';
  static const String wmUnquoted = '/dashboard_wm/wm_unquoted';
  static const String wmReviewed = '/dashboard_wm/wm_reviewed';
  static const String wmAuthorized = '/dashboard_wm/wm_authorized';
  static const String wmCompleted = '/dashboard_wm/wm_completed';
  static const String wmWorkload = '/dashboard_wm/wm_completed';
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

      // Admin routes
      case RouteNames.dashboardAdmin:
        return MaterialPageRoute(
          builder: (_) => const DashboardAdminScreen(),
          settings: settings,
        );
      case RouteNames.customers:
        return MaterialPageRoute(
          builder: (_) => const CustomersPage(),
          settings: settings,
        );
      case RouteNames.laborCatalog:
        return MaterialPageRoute(
          builder: (_) => const LaborCatalogScreen(),
          settings: settings,
        );
      case RouteNames.userAccounts:
        return MaterialPageRoute(
          builder: (_) => const UsersPage(),
          settings: settings,
        );
      case RouteNames.services:
        return MaterialPageRoute(
          builder: (_) => const ServiceHubPage(),
          settings: settings,
        );

      // Workshop Manager routes
      case RouteNames.dashboardWm:
        return MaterialPageRoute(
          builder: (_) => const WorkshopManagerDashboard(),
          settings: settings,
        );
      case RouteNames.wmAuthorized:
        return MaterialPageRoute(
          builder: (_) => const WmAuthorizedScreen(),
          settings: settings,
        );
      case RouteNames.wmCompleted:
        return MaterialPageRoute(
          builder: (_) => const WmCompletedScreen(),
          settings: settings,
        );
      case RouteNames.wmReviewed:
        return MaterialPageRoute(
          builder: (_) => const WmReviewedScreen(),
          settings: settings,
        );
      case RouteNames.wmUnquoted:
        return MaterialPageRoute(
          builder: (_) => const WmUnquotedScreen(),
          settings: settings,
        );
      case RouteNames.wmWorkload:
        return MaterialPageRoute(
          builder: (_) => const WorkloadScreen(),
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
