import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';
import 'package:sap_automotriz_app/features/shared/widgets/widgets.dart';
import 'package:sap_automotriz_app/features/services/presentation/widgets/widgets.dart';

class ServiceOperationsScreen extends StatefulWidget {
  const ServiceOperationsScreen({super.key});

  @override
  State<ServiceOperationsScreen> createState() =>
      _ServiceOperationsScreenState();
}

class _ServiceOperationsScreenState extends State<ServiceOperationsScreen> {
  _Section? _activeSection;

  // Mock data
  final List<Service> _inProgress = [
    Service(
      id: 3,
      customerId: 1,
      carId: 1,
      createdByUserId: 1,
      folio: '090326-01',
      channel: ServiceChannel.phoneCall,
      shortDescription: 'Cambio de frenos delanteros',
      status: ServiceStatus.inProgress,
      intakeDate: DateTime(2026, 3, 9),
      estimatedDeliveryDate: DateTime(2026, 3, 11),
      serviceType: ServiceType.general,
    ),
    Service(
      id: 4,
      customerId: 2,
      carId: 3,
      createdByUserId: 1,
      folio: '090326-02',
      channel: ServiceChannel.whatsapp,
      shortDescription: 'Diagnóstico eléctrico completo',
      status: ServiceStatus.authorized,
      intakeDate: DateTime(2026, 3, 9),
      serviceType: ServiceType.general,
    ),
  ];

  final List<Service> _completed = [
    Service(
      id: 5,
      customerId: 3,
      carId: 4,
      createdByUserId: 1,
      folio: '070326-01',
      channel: ServiceChannel.inPerson,
      shortDescription: 'Afinación mayor',
      status: ServiceStatus.delivered,
      intakeDate: DateTime(2026, 3, 7),
      actualDeliveryDate: DateTime(2026, 3, 9),
      serviceType: ServiceType.general,
    ),
    Service(
      id: 6,
      customerId: 1,
      carId: 1,
      createdByUserId: 1,
      folio: '050326-01',
      channel: ServiceChannel.inPerson,
      shortDescription: 'Cambio de clutch',
      status: ServiceStatus.completed,
      intakeDate: DateTime(2026, 3, 5),
      actualDeliveryDate: DateTime(2026, 3, 8),
      serviceType: ServiceType.general,
    ),
  ];

  // Mock quote for the additional charges section
  final Quote _mockQuoteForCharges = Quote(
    id: 3,
    serviceId: 3,
    status: QuoteStatus.draft,
    version: 1,
    lineItems: [
      QuoteLineItem(
        id: 10,
        quoteId: 3,
        description: 'Pastillas de freno Brembo',
        itemType: QuoteItemType.sparePart,
        quantity: 1,
        unitPrice: 850.0,
        totalAmount: 850.0,
        taxable: false,
      ),
    ],
  );

  late Quote _chargesQuote = _mockQuoteForCharges;
  Service? _selectedChargeService;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Quick access cards ────────────────────────────────────────
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 2.0,
          children: [
            QuickCard(
              icon: Icons.engineering_rounded,
              label: 'Servicios en proceso',
              description: 'Autorizados o en progreso',
              color: const Color(0xFFEA580C),
              active: _activeSection == _Section.inProgress,
              onTap: () => setState(
                () => _activeSection = _activeSection == _Section.inProgress
                    ? null
                    : _Section.inProgress,
              ),
            ),
            QuickCard(
              icon: Icons.task_alt_rounded,
              label: 'Servicios finalizados',
              description: 'Completados y entregados',
              color: const Color(0xFF16A34A),
              active: _activeSection == _Section.completed,
              onTap: () => setState(
                () => _activeSection = _activeSection == _Section.completed
                    ? null
                    : _Section.completed,
              ),
            ),
            QuickCard(
              icon: Icons.summarize_outlined,
              label: 'Archivo concentrado',
              description: 'Próximamente',
              color: AppColors.warmGray,
              active: false,
              disabled: true,
              onTap: () {},
            ),
          ],
        ),

        const SizedBox(height: 24),

        // ── Active section content ────────────────────────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _activeSection == null
              ? const SizedBox.shrink()
              : _buildSection(),
        ),
      ],
    );
  }

  Widget _buildSection() {
    switch (_activeSection) {
      case _Section.additionalCharges:
        return _AdditionalChargesSection(
          inProgressServices: _inProgress,
          quote: _chargesQuote,
          selectedService: _selectedChargeService,
          onServiceSelected: (s) => setState(() => _selectedChargeService = s),
          onAddItem: () async {
            if (_selectedChargeService == null) return;
            final result = await showDialog<QuoteLineItem>(
              context: context,
              builder: (_) =>
                  QuoteLineItemFormDialog(quoteId: _chargesQuote.id!),
            );
            if (result != null) {
              setState(() {
                _chargesQuote = _chargesQuote.copyWith(
                  lineItems: [..._chargesQuote.lineItems, result],
                );
              });
            }
          },
          onDeleteItem: (item) => setState(() {
            _chargesQuote = _chargesQuote.copyWith(
              lineItems: _chargesQuote.lineItems
                  .where((i) => i.id != item.id)
                  .toList(),
            );
          }),
        );
      case _Section.inProgress:
        return _ServiceListSection(
          title: 'Servicios en proceso',
          services: _inProgress,
          emptyMessage: 'No hay servicios en proceso',
        );
      case _Section.completed:
        return _ServiceListSection(
          title: 'Servicios finalizados',
          services: _completed,
          emptyMessage: 'No hay servicios finalizados',
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

enum _Section { additionalCharges, inProgress, completed }

// ── Additional charges section ─────────────────────────────────────────────

class _AdditionalChargesSection extends StatelessWidget {
  final List<Service> inProgressServices;
  final Quote quote;
  final Service? selectedService;
  final ValueChanged<Service> onServiceSelected;
  final VoidCallback onAddItem;
  final ValueChanged<QuoteLineItem> onDeleteItem;

  const _AdditionalChargesSection({
    required this.inProgressServices,
    required this.quote,
    required this.selectedService,
    required this.onServiceSelected,
    required this.onAddItem,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDE5DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.add_card_rounded,
                size: 16,
                color: AppColors.crimsonRed,
              ),
              SizedBox(width: 8),
              Text(
                'Cargos adicionales',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Service selector
          DropdownButtonFormField<Service>(
            value: selectedService,
            decoration: const InputDecoration(
              labelText: 'Selecciona el servicio',
              prefixIcon: Icon(Icons.build_circle_outlined),
            ),
            hint: const Text('Selecciona un servicio activo'),
            items: inProgressServices
                .map(
                  (s) => DropdownMenuItem(
                    value: s,
                    child: Text(
                      '${s.folio} — ${s.shortDescription}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) onServiceSelected(v);
            },
          ),

          if (selectedService != null) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFEDE5DC)),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'conceptos existentes',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
                TextButton.icon(
                  onPressed: onAddItem,
                  icon: const Icon(Icons.add_rounded, size: 15),
                  label: const Text('Agregar concepto'),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ...quote.lineItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF6F2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFEDE5DC)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ),
                      Text(
                        'x${item.quantity}  \$${item.totalAmount!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.warmGray,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (item.itemType != QuoteItemType.sparePart)
                        IconButton(
                          onPressed: () => onDeleteItem(item),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 16,
                            color: AppColors.crimsonRed,
                          ),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                        )
                      else
                        const Tooltip(
                          message: 'Agregado por técnico',
                          child: Icon(
                            Icons.lock_outline_rounded,
                            size: 14,
                            color: AppColors.warmGray,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Service list section (in-progress / completed) ─────────────────────────

class _ServiceListSection extends StatelessWidget {
  final String title;
  final List<Service> services;
  final String emptyMessage;

  const _ServiceListSection({
    required this.title,
    required this.services,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDE5DC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 14),
          if (services.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  emptyMessage,
                  style: const TextStyle(
                    color: AppColors.warmGray,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            // Header
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.charcoal,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(flex: 2, child: TableHeaderCell('Folio')),
                      Expanded(flex: 4, child: TableHeaderCell('Descripción')),
                      Expanded(flex: 2, child: TableHeaderCell('Tipo')),
                      Expanded(flex: 2, child: TableHeaderCell('Recepción')),
                      Expanded(flex: 2, child: TableHeaderCell('Entrega est.')),
                      Expanded(flex: 2, child: TableHeaderCell('Estado')),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEDE5DC)),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: services.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFEDE5DC)),
                    itemBuilder: (_, i) {
                      final s = services[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                s.folio,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.charcoal,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                s.shortDescription,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.charcoal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                s.serviceType.label,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.warmGray,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                formatDate(s.intakeDate),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.warmGray,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                formatDate(s.estimatedDeliveryDate),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.warmGray,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: ServiceStatusBadge(status: s.status),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
