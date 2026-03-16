import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/workshop_manager/shared/presentation/widgets/workshop_manager_layout.dart';
import '../widgets/service_card_wm.dart';

class WmCompletedScreen extends StatelessWidget {
  const WmCompletedScreen({super.key});

  static const List<Map<String, dynamic>> _services = [
    {
      'id': 7,
      'folio': '050326-01',
      'shortDescription': 'Cambio de clutch',
      'serviceType': 'general',
      'channel': 'in_person',
      'intakeDate': '05/03/2026',
      'customerName': 'Jorge Villanueva',
      'carLabel': '2023 Ford Ranger — PQR-111',
      'status': 'completed',
      'assignedTechnician': 'Luis Carrillo',
      'completedAt': '08/03/2026',
    },
    {
      'id': 8,
      'folio': '040326-01',
      'shortDescription': 'Afinación menor',
      'serviceType': 'maintenance',
      'channel': 'phone_call',
      'intakeDate': '04/03/2026',
      'customerName': 'Carlos Ramírez',
      'carLabel': '2021 Toyota Corolla — XYZ-456',
      'status': 'completed',
      'assignedTechnician': 'Héctor Vega',
      'completedAt': '05/03/2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WorkshopManagerLayout(
      pageTitle: 'Finalizados por técnicos',
      showBackButton: true,
      child: _services.isEmpty
          ? const Center(
              child: Text(
                'No hay servicios finalizados',
                style: TextStyle(color: AppColors.warmGray, fontSize: 14),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _services.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final s = _services[i];
                return ServiceCardWm(
                  service: s,
                  primaryActionLabel: 'Notificar al administrador',
                  primaryActionIcon: Icons.notification_add_outlined,
                  primaryActionColor: const Color(0xFF16A34A),
                  onPrimaryAction: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Administrador notificado — ${s['folio']}',
                        ),
                        backgroundColor: const Color(0xFF16A34A),
                      ),
                    );
                  },
                  bottomInfo: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 13,
                        color: Color(0xFF16A34A),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Finalizado: ${s['completedAt']}  •  ${s['assignedTechnician']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
