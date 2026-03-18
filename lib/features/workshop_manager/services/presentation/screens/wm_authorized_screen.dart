import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/admin/customers/domain/entities/car.dart';
import 'package:sap_automotriz_app/features/admin/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';
import 'package:sap_automotriz_app/features/users/domain/entities/user.dart';
import 'package:sap_automotriz_app/features/workshop_manager/services/presentation/widgets/service_assignment_sheet.dart';
import 'package:sap_automotriz_app/features/workshop_manager/shared/presentation/widgets/workshop_manager_layout.dart';
import '../widgets/service_card_wm.dart';

class WmAuthorizedScreen extends StatefulWidget {
  const WmAuthorizedScreen({super.key});

  @override
  State<WmAuthorizedScreen> createState() => _WmAuthorizedScreenState();
}

class _WmAuthorizedScreenState extends State<WmAuthorizedScreen> {
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

  final List<UserAccount> _technicians = [
    UserAccount(
      id: 3,
      email: 'tecnico1@tallermec.com',
      fullName: 'Jorge Herrera Salinas',
      role: UserRole.technician,
      password: 'hashed_password_3',
      salary: 12000.00,
      phone: '4773456789',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    ),
  ];

  void _openAssignSheet(Service service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ServiceAssignmentSheet(
        service: service,
        technicians: _technicians,
        onConfirm: (assigned, leadId) {
          setState(() {
            // TODO: Asignar un servicio a un técnico
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Técnicos asignados. Servicio iniciado.'),
              backgroundColor: Color(0xFF16A34A),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WorkshopManagerLayout(
      pageTitle: 'Aprobados por cliente',
      showBackButton: true,
      child: _services.isEmpty
          ? const Center(
              child: Text(
                'No hay servicios autorizados pendientes',
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
                final assigned = ['Técnico 1', 'Técnico 2', 'Técnico 3'];
                return ServiceCardWm(
                  service: service,
                  car: car,
                  customer: customer,
                  primaryActionLabel: assigned.isEmpty
                      ? 'Asignar técnico(s)'
                      : 'Modificar asignación',
                  primaryActionIcon: Icons.group_add_rounded,
                  primaryActionColor: AppColors.golden,
                  onPrimaryAction: () => _openAssignSheet(service),
                  bottomInfo: assigned.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 13,
                                  color: AppColors.golden,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Líder: Nombre del técnico líder',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.golden,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            if (assigned.length > 1) ...[
                              const SizedBox(height: 3),
                              Text(
                                'Equipo: ${assigned.join(', ')}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.warmGray,
                                ),
                              ),
                            ],
                          ],
                        )
                      : null,
                );
              },
            ),
    );
  }
}
