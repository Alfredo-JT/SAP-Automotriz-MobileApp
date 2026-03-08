import 'package:flutter/material.dart';
import 'config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAP Automotriz App',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: RouteNames.login,
      theme: AppTheme().getTheme(),
    );
  }
}
