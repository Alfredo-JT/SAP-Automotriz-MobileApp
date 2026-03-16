import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';

class WorkshopManagerLayout extends StatelessWidget {
  final String pageTitle;
  final Widget child;
  final List<Widget>? actions;
  final bool showBackButton;

  const WorkshopManagerLayout({
    super.key,
    required this.pageTitle,
    required this.child,
    this.actions,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE4),
      appBar: AppBar(
        backgroundColor: AppColors.charcoal,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.crimsonRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pageTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              'Jefe de Taller',
              style: TextStyle(
                color: AppColors.warmGray,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: [
          if (actions != null) ...actions!,
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.warmGray,
              size: 20,
            ),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, RouteNames.login),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: child,
    );
  }
}
