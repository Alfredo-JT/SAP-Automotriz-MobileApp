import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/services/data/services_quoted_mock.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';
import 'package:sap_automotriz_app/features/services/infrastructure/models/service_with_quote_model.dart';
import 'package:sap_automotriz_app/features/workshop_manager/shared/presentation/widgets/workshop_manager_layout.dart';
import '../widgets/service_card_wm.dart';
import '../widgets/quote_line_items_preview.dart';

class WmReviewedScreen extends StatefulWidget {
  const WmReviewedScreen({super.key});

  @override
  State<WmReviewedScreen> createState() => _WmReviewedScreenState();
}

class _WmReviewedScreenState extends State<WmReviewedScreen> {
  final List<ServiceWithQuoteModel> _services = quotedServicesMock
      .map((json) => ServiceWithQuoteModel.fromJson(json))
      .toList();

  void _approveQuote(Service service) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Aprobar cotización'),
        content: Text(
          '¿Aprobar la cotización del folio ${service.folio} para enviarla al administrador?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Actualizar el esta del servicio a "authorized"
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

  void _returnToUnquoted(Service service) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Devolver a revisión'),
        content: Text(
          '¿Devolver el folio ${service.folio} al estado "Sin Cotizar" para que el técnico lo revise de nuevo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
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
                final serviceWithQuote = _services[i];
                final service = serviceWithQuote.service;
                final car = serviceWithQuote.service.car;
                final customer = serviceWithQuote.service.customer;
                final lineItems = serviceWithQuote.quote?.lineItems ?? [];
                final total = serviceWithQuote.quote?.total ?? 0.0;

                return ServiceCardWm(
                  service: service,
                  car: car,
                  customer: customer,
                  primaryActionLabel: 'Aprobar cotización',
                  primaryActionIcon: Icons.check_circle_outline_rounded,
                  primaryActionColor: Color(0xFF2563EB),
                  onPrimaryAction: () => _approveQuote(service),
                  secondaryActions: [
                    SecondaryAction(
                      label: 'Devolver a técnico',
                      icon: Icons.undo_rounded,
                      color: Color(0xFF2563EB),
                      onTap: () => _returnToUnquoted(service),
                    ),
                  ],
                  bottomInfo: QuoteLineItemsPreview(
                    lineItems: lineItems,
                    total: total,
                  ),
                );
              },
            ),
    );
  }
}
