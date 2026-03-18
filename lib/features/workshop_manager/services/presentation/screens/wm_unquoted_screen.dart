import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/admin/customers/domain/entities/car.dart';
import 'package:sap_automotriz_app/features/admin/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';
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

  final List<Service> _services = [
    Service(
      id: 1,
      customerId: 1,
      carId: 1,
      createdByUserId: 1,
      folio: '100326-01',
      channel: ServiceChannel.inPerson,
      shortDescription: 'Cambio de aceite y revisión general',
      status: ServiceStatus.quoted,
      intakeDate: DateTime(2026, 3, 10),
      serviceType: ServiceType.general,
      customer: Customer(
        id: 1,
        fullName: 'Carlos Ramírez',
        phone: '461-123-4567',
      ),
      car: Car(
        id: 1,
        customerId: 1,
        make: 'Nissan',
        model: 'Versa',
        year: 2019,
        color: 'Blanco',
        licensePlate: 'ABC-123',
      ),
    ),
    Service(
      id: 2,
      customerId: 2,
      carId: 3,
      createdByUserId: 1,
      folio: '080326-02',
      channel: ServiceChannel.whatsapp,
      shortDescription: 'Balanceo y alineación + revisión suspensión',
      status: ServiceStatus.quoted,
      intakeDate: DateTime(2026, 3, 8),
      serviceType: ServiceType.alignmentBalancing,
      customer: Customer(
        id: 2,
        fullName: 'Laura González',
        phone: '461-987-6543',
      ),
      car: Car(
        id: 3,
        customerId: 2,
        make: 'Chevrolet',
        model: 'Aveo',
        year: 2018,
        color: 'Rojo',
        licensePlate: 'DEF-789',
      ),
    ),
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

  void _openAssignSheet(Service service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AssignTechnicianSheet(
        service: service,
        technicians: _technicians,
        onAssign: (technicianId, technicianName) {
          setState(() {
            // TODO: Creación de un service_technician para asignar un Servicio a Técnico
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
                final service = _services[i];
                final car = service.car;
                final customer = service.customer;

                return ServiceCardWm(
                  service: service,
                  car: car,
                  customer: customer,
                  primaryActionLabel: 'Asignar técnico',
                  primaryActionIcon: Icons.person_add_rounded,
                  primaryActionColor: const Color(0xFF7C3AED),
                  onPrimaryAction: () => _openAssignSheet(service),
                );
              },
            ),
    );
  }
}
