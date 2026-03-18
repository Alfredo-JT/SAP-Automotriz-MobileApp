import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/admin/customers/domain/entities/car.dart';
import 'package:sap_automotriz_app/features/admin/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';
import 'package:sap_automotriz_app/features/workshop_manager/shared/presentation/widgets/workshop_manager_layout.dart';
import '../widgets/service_card_wm.dart';

class WmCompletedScreen extends StatelessWidget {
  WmCompletedScreen({super.key});

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
                final service = _services[i];
                final car = service.car;
                final customer = service.customer;

                return ServiceCardWm(
                  service: service,
                  car: car,
                  customer: customer,
                  primaryActionLabel: 'Notificar al administrador',
                  primaryActionIcon: Icons.notification_add_outlined,
                  primaryActionColor: const Color(0xFF16A34A),
                  onPrimaryAction: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Administrador notificado — ${service.folio}',
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
                        'Finalizado: ${service.actualDeliveryDate}  •  Nombre del técnico que lo realizó]}',
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
