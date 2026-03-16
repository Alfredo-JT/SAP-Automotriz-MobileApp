import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/workshop_manager/shared/presentation/widgets/workshop_manager_layout.dart';
import '../widgets/service_card_wm.dart';
import '../widgets/assign_technician_sheet.dart';
import 'workload_screen.dart';

class WmUnquotedScreen extends StatefulWidget {
  const WmUnquotedScreen({super.key});

  @override
  State<WmUnquotedScreen> createState() => _WmUnquotedScreenState();
}

class _WmUnquotedScreenState extends State<WmUnquotedScreen> {
  // Mock services — replace with BLoC
  final List<Map<String, dynamic>> _services = [
    {
      'id': 1,
      'folio': '100326-01',
      'shortDescription': 'Cambio de aceite y revisión general',
      'serviceType': 'general',
      'channel': 'in_person',
      'intakeDate': '10/03/2026',
      'customerName': 'Carlos Ramírez',
      'carLabel': '2019 Nissan Versa — ABC-123',
      'status': 'under_review',
      'assignedTechnician': null,
    },
    {
      'id': 2,
      'folio': '100326-02',
      'shortDescription': 'Diagnóstico eléctrico — falla de arranque',
      'serviceType': 'general',
      'channel': 'whatsapp',
      'intakeDate': '10/03/2026',
      'customerName': 'Laura González',
      'carLabel': '2018 Chevrolet Aveo — DEF-789',
      'status': 'not_started',
      'assignedTechnician': null,
    },
    {
      'id': 3,
      'folio': '090326-03',
      'shortDescription': 'Revisión de suspensión trasera',
      'serviceType': 'general',
      'channel': 'phone_call',
      'intakeDate': '09/03/2026',
      'customerName': 'Roberto Hernández',
      'carLabel': '2020 Volkswagen Jetta — GHI-321',
      'status': 'under_review',
      'assignedTechnician': 'Luis Carrillo',
    },
  ];

  // Mock technicians
  final List<Map<String, dynamic>> _technicians = [
    {
      'id': 2,
      'name': 'Luis Carrillo',
      'standardHoursToday': 3.5,
      'activeServices': 2,
    },
    {
      'id': 3,
      'name': 'Héctor Vega',
      'standardHoursToday': 1.0,
      'activeServices': 1,
    },
    {
      'id': 4,
      'name': 'Mario Soto',
      'standardHoursToday': 0.0,
      'activeServices': 0,
    },
  ];

  void _openAssignSheet(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AssignTechnicianSheet(
        service: service,
        technicians: _technicians,
        onAssign: (technicianId, technicianName) {
          setState(() {
            final idx = _services.indexWhere((s) => s['id'] == service['id']);
            if (idx != -1) {
              _services[idx]['assignedTechnician'] = technicianName;
            }
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Servicio asignado a $technicianName'),
              backgroundColor: const Color(0xFF16A34A),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WorkshopManagerLayout(
      pageTitle: 'Sin Cotizar / Recotización',
      showBackButton: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.people_alt_outlined,
            color: Colors.white,
            size: 20,
          ),
          tooltip: 'Ver carga de trabajo',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WorkloadScreen()),
          ),
        ),
      ],
      child: _services.isEmpty
          ? const Center(
              child: Text(
                'No hay servicios pendientes',
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
                  primaryActionLabel: s['assignedTechnician'] == null
                      ? 'Asignar técnico'
                      : 'Reasignar técnico',
                  primaryActionIcon: Icons.person_add_rounded,
                  primaryActionColor: const Color(0xFF7C3AED),
                  onPrimaryAction: () => _openAssignSheet(s),
                  bottomInfo: s['assignedTechnician'] != null
                      ? Row(
                          children: [
                            const Icon(
                              Icons.engineering_rounded,
                              size: 13,
                              color: Color(0xFF7C3AED),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Asignado: ${s['assignedTechnician']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF7C3AED),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : null,
                );
              },
            ),
    );
  }
}
