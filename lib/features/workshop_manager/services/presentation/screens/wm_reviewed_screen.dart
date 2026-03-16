import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/workshop_manager/shared/presentation/widgets/workshop_manager_layout.dart';
import '../widgets/service_card_wm.dart';

class WmReviewedScreen extends StatefulWidget {
  const WmReviewedScreen({super.key});

  @override
  State<WmReviewedScreen> createState() => _WmReviewedScreenState();
}

class _WmReviewedScreenState extends State<WmReviewedScreen> {
  final List<Map<String, dynamic>> _services = [
    {
      'id': 4,
      'folio': '080326-02',
      'shortDescription': 'Balanceo y alineación + revisión suspensión',
      'serviceType': 'alignment_balancing',
      'channel': 'whatsapp',
      'intakeDate': '08/03/2026',
      'customerName': 'Laura González',
      'carLabel': '2018 Chevrolet Aveo — DEF-789',
      'status': 'quoted',
      'assignedTechnician': 'Luis Carrillo',
      'quoteTotal': 1218.00,
      'lineItemsCount': 3,
    },
    {
      'id': 5,
      'folio': '070326-01',
      'shortDescription': 'Cambio de frenos delanteros',
      'serviceType': 'general',
      'channel': 'in_person',
      'intakeDate': '07/03/2026',
      'customerName': 'Roberto Hernández',
      'carLabel': '2020 VW Jetta — GHI-321',
      'status': 'quoted',
      'assignedTechnician': 'Héctor Vega',
      'quoteTotal': 2050.00,
      'lineItemsCount': 4,
    },
  ];

  void _approveQuote(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Aprobar cotización'),
        content: Text(
          '¿Aprobar la cotización del folio ${service['folio']} para enviarla al administrador?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(
                () => _services.removeWhere((s) => s['id'] == service['id']),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Cotización aprobada y enviada al administrador',
                  ),
                  backgroundColor: Color(0xFF16A34A),
                ),
              );
            },
            child: const Text('Aprobar'),
          ),
        ],
      ),
    );
  }

  void _returnToUnquoted(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Devolver a revisión'),
        content: Text(
          '¿Devolver el folio ${service['folio']} al estado "Sin Cotizar" para que el técnico lo revise de nuevo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(
                () => _services.removeWhere((s) => s['id'] == service['id']),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Servicio devuelto a revisión'),
                  backgroundColor: AppColors.golden,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.golden,
              foregroundColor: AppColors.charcoal,
            ),
            child: const Text('Devolver'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WorkshopManagerLayout(
      pageTitle: 'Revisados / Cotizados',
      showBackButton: true,
      child: _services.isEmpty
          ? const Center(
              child: Text(
                'No hay cotizaciones por revisar',
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
                  primaryActionLabel: 'Aprobar cotización',
                  primaryActionIcon: Icons.check_circle_outline_rounded,
                  primaryActionColor: const Color(0xFF16A34A),
                  onPrimaryAction: () => _approveQuote(s),
                  secondaryActions: [
                    SecondaryAction(
                      label: 'Devolver',
                      icon: Icons.undo_rounded,
                      color: AppColors.golden,
                      onTap: () => _returnToUnquoted(s),
                    ),
                  ],
                  bottomInfo: Row(
                    children: [
                      const Icon(
                        Icons.receipt_outlined,
                        size: 13,
                        color: Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${s['lineItemsCount']} partidas  •  \$${(s['quoteTotal'] as double).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2563EB),
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

// class SecondaryAction {
//   final String label;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;
//   const SecondaryAction({
//     required this.label,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });
// }
