import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/admin/shared/presentation/widgets/widgets.dart';
import 'package:sap_automotriz_app/features/shared/widgets/widgets.dart';

class DashboardAdminScreen extends StatelessWidget {
  const DashboardAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentRoute: RouteNames.dashboardAdmin,
      pageTitle: 'Dashboard Admin',
      // actions: [
      //   TextButton(onPressed: () {}, child: const Text('Cerrar sesión')),
      // ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.2,
            children: const [
              SummaryCard(
                icon: Icons.build_circle_rounded,
                label: 'Servicios activos',
                value: '12',
                color: AppColors.crimsonRed,
              ),
              SummaryCard(
                icon: Icons.people_alt_rounded,
                label: 'Clientes',
                value: '84',
                color: Color(0xFF2563EB),
              ),
              SummaryCard(
                icon: Icons.receipt_long_rounded,
                label: 'Cotizaciones',
                value: '5',
                color: AppColors.golden,
              ),
              SummaryCard(
                icon: Icons.check_circle_rounded,
                label: 'Entregados hoy',
                value: '3',
                color: Color(0xFF16A34A),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Quick access
          const Text(
            'Acceso rápido',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              QuickAccessCard(
                icon: Icons.people_alt_rounded,
                label: 'Clientes',
                description: 'Gestionar clientes y vehículos',
                onTap: () => Navigator.pushNamed(context, RouteNames.customers),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
