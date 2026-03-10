import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/car.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/dashboard/presentation/widgets/widgets.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';
import 'package:sap_automotriz_app/features/services/presentation/widgets/widgets.dart';

class QuoteCompletionScreen extends StatefulWidget {
  const QuoteCompletionScreen({super.key});

  @override
  State<QuoteCompletionScreen> createState() => _QuoteCompletionScreenState();
}

class _QuoteCompletionScreenState extends State<QuoteCompletionScreen> {
  Service? _selectedService;

  // Mock data — replace with BLoC (only 'quoted' services)
  final List<Service> _quotedServices = [
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

  // Mock quotes with existing spare_part items from technician
  final Map<int, Quote> _quotes = {
    1: Quote(
      id: 1,
      serviceId: 1,
      status: QuoteStatus.draft,
      version: 1,
      lineItems: [
        QuoteLineItem(
          id: 1,
          quoteId: 1,
          description: 'Filtro de aceite',
          itemType: QuoteItemType.sparePart,
          quantity: 1,
          unitPrice: 120.0,
          totalAmount: 120.0,
          taxable: false,
        ),
        QuoteLineItem(
          id: 2,
          quoteId: 1,
          description: 'Aceite 5W-30 sintético',
          itemType: QuoteItemType.sparePart,
          quantity: 4,
          unitPrice: 85.0,
          totalAmount: 340.0,
          taxable: false,
          unit: 'lt',
        ),
      ],
    ),
    2: Quote(
      id: 2,
      serviceId: 2,
      status: QuoteStatus.draft,
      version: 1,
      lineItems: [
        QuoteLineItem(
          id: 3,
          quoteId: 2,
          description: 'Masas de balanceo',
          itemType: QuoteItemType.sparePart,
          quantity: 1,
          unitPrice: 200.0,
          totalAmount: 200.0,
          taxable: false,
          unit: 'juego',
        ),
      ],
    ),
  };

  DateTime? _estimatedDelivery;

  Quote? get _currentQuote =>
      _selectedService != null ? _quotes[_selectedService!.id] : null;

  double get _subtotal =>
      _currentQuote?.lineItems.fold(0.0, (sum, i) => sum! + i.totalAmount) ?? 0;

  double get _taxTotal =>
      _currentQuote?.lineItems
          .where((i) => i.taxable)
          .fold(0.0, (sum, i) => sum! + (i.taxAmount ?? 0)) ??
      0;

  double get _grandTotal => _subtotal + _taxTotal;

  void _addLineItem() async {
    if (_currentQuote == null) return;
    final result = await showDialog<QuoteLineItem>(
      context: context,
      builder: (_) => QuoteLineItemFormDialog(quoteId: _currentQuote!.id!),
    );
    if (result != null) {
      setState(() {
        final updated = _currentQuote!.copyWith(
          lineItems: [..._currentQuote!.lineItems, result],
        );
        _quotes[_selectedService!.id!] = updated;
      });
    }
  }

  void _editLineItem(QuoteLineItem item) async {
    if (_currentQuote == null) return;
    final result = await showDialog<QuoteLineItem>(
      context: context,
      builder: (_) =>
          QuoteLineItemFormDialog(quoteId: _currentQuote!.id!, item: item),
    );
    if (result != null) {
      setState(() {
        final updated = _currentQuote!.copyWith(
          lineItems: _currentQuote!.lineItems
              .map((i) => i.id == item.id ? result : i)
              .toList(),
        );
        _quotes[_selectedService!.id!] = updated;
      });
    }
  }

  void _deleteLineItem(QuoteLineItem item) {
    setState(() {
      final updated = _currentQuote!.copyWith(
        lineItems: _currentQuote!.lineItems
            .where((i) => i.id != item.id)
            .toList(),
      );
      _quotes[_selectedService!.id!] = updated;
    });
  }

  Future<void> _pickDeliveryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _estimatedDelivery ??
          (_selectedService?.intakeDate.add(const Duration(days: 3)) ??
              DateTime.now()),
      firstDate: _selectedService?.intakeDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _estimatedDelivery = picked);
  }

  Color _itemTypeColor(QuoteItemType t) {
    switch (t) {
      case QuoteItemType.sparePart:
        return const Color(0xFF2563EB);
      case QuoteItemType.labor:
        return AppColors.crimsonRed;
      case QuoteItemType.additionalExpense:
        return AppColors.golden;
      case QuoteItemType.externalService:
        return const Color(0xFF7C3AED);
      case QuoteItemType.other:
        return AppColors.warmGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Service list ──────────────────────────────────────────────
        SizedBox(
          width: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SERVICIOS COTIZADOS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppColors.warmGray,
                ),
              ),
              const SizedBox(height: 10),
              ..._quotedServices.map((s) {
                final selected = _selectedService?.id == s.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedService = s;
                      _estimatedDelivery = s.estimatedDeliveryDate;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.crimsonRed.withOpacity(0.06)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? AppColors.crimsonRed
                              : const Color(0xFFEDE5DC),
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                s.folio,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: selected
                                      ? AppColors.crimsonRed
                                      : AppColors.charcoal,
                                  letterSpacing: 1,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                channelIcon(s.channel),
                                size: 13,
                                color: AppColors.warmGray,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            s.customer?.fullName ?? '—',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.charcoal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            s.car != null
                                ? '${s.car!.year} ${s.car!.make} ${s.car!.model}'
                                : '—',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.warmGray,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(width: 20),

        // ── Quote editor ──────────────────────────────────────────────
        Expanded(
          child: _selectedService == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        size: 48,
                        color: AppColors.warmGray.withOpacity(0.4),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Selecciona un servicio para editar su cotización',
                        style: TextStyle(
                          color: AppColors.warmGray,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service header
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEDE5DC)),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedService!.folio,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.charcoal,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _selectedService!.shortDescription,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.warmGray,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Estimated delivery picker
                          GestureDetector(
                            onTap: _pickDeliveryDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _estimatedDelivery != null
                                      ? AppColors.crimsonRed
                                      : AppColors.warmGray,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.event_outlined,
                                    size: 15,
                                    color: _estimatedDelivery != null
                                        ? AppColors.crimsonRed
                                        : AppColors.warmGray,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _estimatedDelivery != null
                                        ? 'Entrega: ${formatDate(_estimatedDelivery)}'
                                        : 'Fecha entrega estimada',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _estimatedDelivery != null
                                          ? AppColors.crimsonRed
                                          : AppColors.warmGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ServiceStatusBadge(status: _selectedService!.status),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Line items table
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEDE5DC)),
                      ),
                      child: Column(
                        children: [
                          // Table header
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: const BoxDecoration(
                              color: AppColors.charcoal,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(11),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 4,
                                  child: _TH('Descripción'),
                                ),
                                const Expanded(flex: 2, child: _TH('Tipo')),
                                const _TH('Cant.'),
                                const SizedBox(width: 16),
                                const Expanded(child: _TH('P. Unit.')),
                                const Expanded(child: _TH('Total')),
                                const SizedBox(width: 72),
                              ],
                            ),
                          ),

                          if (_currentQuote!.lineItems.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(
                                child: Text(
                                  'Sin partidas aún',
                                  style: TextStyle(
                                    color: AppColors.warmGray,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _currentQuote!.lineItems.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                color: Color(0xFFEDE5DC),
                              ),
                              itemBuilder: (_, i) {
                                final item = _currentQuote!.lineItems[i];
                                final isAdminItem =
                                    item.itemType != QuoteItemType.sparePart;
                                final typeColor = _itemTypeColor(item.itemType);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          item.description,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.charcoal,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: typeColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            item.itemType.label,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: typeColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${item.quantity}${item.unit != null ? ' ${item.unit}' : ''}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.charcoal,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          '\$${item.unitPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.charcoal,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '\$${item.totalAmount.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.charcoal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 72,
                                        child: Row(
                                          children: [
                                            if (isAdminItem) ...[
                                              IconButton(
                                                onPressed: () =>
                                                    _editLineItem(item),
                                                icon: const Icon(
                                                  Icons.edit_outlined,
                                                  size: 16,
                                                  color: AppColors.warmGray,
                                                ),
                                                constraints:
                                                    const BoxConstraints(),
                                                padding: const EdgeInsets.all(
                                                  5,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () =>
                                                    _deleteLineItem(item),
                                                icon: const Icon(
                                                  Icons.delete_outline_rounded,
                                                  size: 16,
                                                  color: AppColors.crimsonRed,
                                                ),
                                                constraints:
                                                    const BoxConstraints(),
                                                padding: const EdgeInsets.all(
                                                  5,
                                                ),
                                              ),
                                            ] else
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  left: 8,
                                                ),
                                                child: Tooltip(
                                                  message:
                                                      'Agregado por técnico',
                                                  child: Icon(
                                                    Icons.lock_outline_rounded,
                                                    size: 14,
                                                    color: AppColors.warmGray,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                          // Add button row
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: TextButton.icon(
                              onPressed: _addLineItem,
                              icon: const Icon(Icons.add_rounded, size: 16),
                              label: const Text('Agregar partida'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Totals + save
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _TotalRow(label: 'Subtotal', value: _subtotal),
                            if (_taxTotal > 0)
                              _TotalRow(label: 'IVA', value: _taxTotal),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.charcoal,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Text(
                                  '\$ ${_grandTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.crimsonRed,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Cotización guardada correctamente',
                                ),
                                backgroundColor: Color(0xFF16A34A),
                              ),
                            );
                          },
                          icon: const Icon(Icons.save_outlined, size: 18),
                          label: const Text('Guardar cotización'),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _TH extends StatelessWidget {
  final String text;
  const _TH(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double value;
  const _TotalRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.warmGray),
          ),
          const SizedBox(width: 24),
          Text(
            '\$ ${value.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 13, color: AppColors.charcoal),
          ),
        ],
      ),
    );
  }
}
