import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/workshop_manager/services/presentation/widgets/section_card_wm.dart';
import 'package:sap_automotriz_app/features/workshop_manager/shared/presentation/widgets/workshop_manager_layout.dart';

class WorkshopManagerDashboard extends StatelessWidget {
  const WorkshopManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return WorkshopManagerLayout(
      pageTitle: 'Dashboard',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            const SizedBox(height: 4),
            const Text(
              'Servicios clasificados por estado',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.black,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),

            // Section cards
            SectionCard(
              icon: Icons.assignment_outlined,
              title: 'Sin Cotizar / Recotización',
              description:
                  'Asigne un servicio a un técnico para que realice la cotización inicial.',
              color: const Color(0xFF7C3AED),
              badge: '3',
              onTap: () => Navigator.pushNamed(context, RouteNames.wmUnquoted),
            ),
            const SizedBox(height: 12),
            SectionCard(
              icon: Icons.rate_review_outlined,
              title: 'Revisados / Cotizados por técnicos',
              description:
                  'Apruebe las cotizaciones o devuelvalas para revisión.',
              color: const Color(0xFF2563EB),
              badge: '2',
              onTap: () => Navigator.pushNamed(context, RouteNames.wmReviewed),
            ),
            const SizedBox(height: 12),
            SectionCard(
              icon: Icons.engineering_rounded,
              title: 'Cotizaciones aprobadas por cliente',
              description:
                  'Asigne técnico(s) para iniciar el trabajo de un servicio.',
              color: AppColors.golden,
              badge: '1',
              onTap: () =>
                  Navigator.pushNamed(context, RouteNames.wmAuthorized),
            ),
            const SizedBox(height: 12),
            SectionCard(
              icon: Icons.task_alt_rounded,
              title: 'Finalizados por técnicos',
              description:
                  'Servicios marcados como completados por los técnicos.',
              color: const Color(0xFF16A34A),
              badge: '4',
              onTap: () => Navigator.pushNamed(context, RouteNames.wmCompleted),
            ),

            const SizedBox(height: 24),

            // Workload preview
            _WorkloadPreview(),
          ],
        ),
      ),
    );
  }
}

// TODO: Implementar un Widget de Calendar
// ── Workload preview widget ────────────────────────────────────────────────
class _WorkloadPreview extends StatelessWidget {
  // Mock technicians — replace with BLoC
  final List<Map<String, dynamic>> _technicians = const [
    {
      'name': 'Luis Carrillo',
      'activeServices': 2,
      'standardHoursToday': 3.5,
      'standardHoursWeek': 18.0,
    },
    {
      'name': 'Héctor Vega',
      'activeServices': 1,
      'standardHoursToday': 1.0,
      'standardHoursWeek': 9.0,
    },
    {
      'name': 'Mario Soto',
      'activeServices': 0,
      'standardHoursToday': 0.0,
      'standardHoursWeek': 4.5,
    },
  ];

  const _WorkloadPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Carga de trabajo',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.charcoal,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.wmWorkload),
              child: const Text('Ver detalle'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._technicians.map(
          (t) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _TechnicianWorkloadRow(technician: t),
          ),
        ),
      ],
    );
  }
}

class _TechnicianWorkloadRow extends StatelessWidget {
  final Map<String, dynamic> technician;
  const _TechnicianWorkloadRow({required this.technician});

  Color get _loadColor {
    final hours = technician['standardHoursToday'] as double;
    if (hours == 0) return AppColors.warmGray;
    if (hours <= 4) return const Color(0xFF16A34A);
    if (hours <= 7) return AppColors.golden;
    return AppColors.crimsonRed;
  }

  @override
  Widget build(BuildContext context) {
    final hoursToday = technician['standardHoursToday'] as double;
    final hoursWeek = technician['standardHoursWeek'] as double;
    final activeServices = technician['activeServices'] as int;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEDE5DC)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: _loadColor.withOpacity(0.12),
            child: Text(
              (technician['name'] as String)[0],
              style: TextStyle(
                color: _loadColor,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  technician['name'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$activeServices servicio${activeServices != 1 ? 's' : ''} activo${activeServices != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.warmGray,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.today_outlined, size: 11, color: _loadColor),
                  const SizedBox(width: 3),
                  Text(
                    '${hoursToday}h hoy',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _loadColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${hoursWeek}h semana',
                style: const TextStyle(fontSize: 10, color: AppColors.warmGray),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
