import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/admin/shared/presentation/widgets/widgets.dart';
import 'package:sap_automotriz_app/features/shared/widgets/widgets.dart';

class AdminSidebar extends StatelessWidget {
  final String currentRoute;
  const AdminSidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: AppColors.charcoal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo / Brand
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF2E2B2C), width: 1),
              ),
            ),
            child: Row(
              children: [
                StyledIconBox(
                  backgroundColor: AppColors.crimsonRed,
                  icon: Icons.directions_car_rounded,
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SAP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'Automotriz',
                      style: TextStyle(
                        color: AppColors.warmGray,
                        fontSize: 10,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Nav items
          _SidebarSection(
            label: 'PRINCIPAL',
            items: [
              NavItem(
                icon: Icons.dashboard_rounded,
                label: 'Dashboard',
                route: RouteNames.dashboardAdmin,
                currentRoute: currentRoute,
              ),
            ],
          ),
          _SidebarSection(
            label: 'USUARIOS',
            items: [
              NavItem(
                icon: Icons.engineering,
                label: 'Trabajadores',
                route: RouteNames.userAccounts,
                currentRoute: currentRoute,
              ),
              NavItem(
                icon: Icons.people_alt_rounded,
                label: 'Clientes',
                route: RouteNames.customers,
                currentRoute: currentRoute,
              ),
            ],
          ),
          _SidebarSection(
            label: 'SERVICIOS',
            items: [
              NavItem(
                icon: Icons.miscellaneous_services,
                label: 'Servicios',
                route: RouteNames.services,
                currentRoute: currentRoute,
              ),
            ],
          ),
          // _SidebarSection(
          //   label: 'Catalogo de Actividades de Mano de Obra',
          //   items: [
          //     NavItem(
          //       icon: Icons.build_rounded,
          //       label: 'Acts de Mano de Obra',
          //       route: RouteNames.laborCatalog,
          //       currentRoute: currentRoute,
          //     ),
          //   ],
          // ),
          const Spacer(),

          // User info at bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFF2E2B2C), width: 1),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.crimsonRed.withOpacity(0.2),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.crimsonRed,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Administrador',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'admin',
                        style: TextStyle(
                          color: AppColors.warmGray,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, RouteNames.login),
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.warmGray,
                    size: 18,
                  ),
                  tooltip: 'Cerrar sesión',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarSection extends StatelessWidget {
  final String label;
  final List<NavItem> items;
  const _SidebarSection({required this.label, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.warmGray,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}
