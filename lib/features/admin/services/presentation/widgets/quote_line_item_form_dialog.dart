import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/admin/service_labor/domain/entities/labor_catalog.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';

// Item types the admin is allowed to create (not spare_part, that's the technician)
const List<QuoteItemType> _adminItemTypes = [
  QuoteItemType.labor,
  QuoteItemType.additionalExpense,
  QuoteItemType.externalService,
  QuoteItemType.other,
];

class QuoteLineItemFormDialog extends StatefulWidget {
  final QuoteLineItem? item;
  final int quoteId;

  const QuoteLineItemFormDialog({super.key, this.item, required this.quoteId});

  @override
  State<QuoteLineItemFormDialog> createState() =>
      _QuoteLineItemFormDialogState();
}

class _QuoteLineItemFormDialogState extends State<QuoteLineItemFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late QuoteItemType _itemType;
  late final TextEditingController _descController;
  late final TextEditingController _qtyController;
  late final TextEditingController _unitPriceController;
  late final TextEditingController _unitController;
  bool _taxable = false;
  LaborCatalog? _selectedLabor;

  // Mock labor catalog — replace with BLoC
  final List<LaborCatalog> _laborCatalog = [
    LaborCatalog(
      id: 1,
      name: 'Cambio de aceite y filtro',
      standardHours: 0.5,
      basePrice: 350.0,
    ),
    LaborCatalog(
      id: 2,
      name: 'Alineación y balanceo',
      standardHours: 1.0,
      basePrice: 650.0,
    ),
    LaborCatalog(
      id: 3,
      name: 'Cambio de frenos delanteros',
      standardHours: 2.5,
      basePrice: 1200.0,
    ),
    LaborCatalog(
      id: 4,
      name: 'Diagnóstico computarizado',
      standardHours: 1.0,
      basePrice: 500.0,
    ),
  ];

  bool get isEditing => widget.item != null;

  double get _computedTotal {
    final qty = int.tryParse(_qtyController.text) ?? 0;
    final price = double.tryParse(_unitPriceController.text) ?? 0;
    return qty * price;
  }

  @override
  void initState() {
    super.initState();
    _itemType = widget.item?.itemType ?? QuoteItemType.additionalExpense;
    _descController = TextEditingController(
      text: widget.item?.description ?? '',
    );
    _qtyController = TextEditingController(
      text: widget.item?.quantity.toString() ?? '1',
    );
    _unitPriceController = TextEditingController(
      text: widget.item?.unitPrice!.toStringAsFixed(2) ?? '',
    );
    _unitController = TextEditingController(text: widget.item?.unit ?? '');
    _taxable = widget.item?.taxable ?? false;
  }

  @override
  void dispose() {
    _descController.dispose();
    _qtyController.dispose();
    _unitPriceController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _onLaborSelected(LaborCatalog? labor) {
    setState(() {
      _selectedLabor = labor;
      if (labor != null) {
        _descController.text = labor.name;
        _unitPriceController.text = labor.basePrice.toStringAsFixed(2);
        _unitController.text = 'hr';
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final total = _computedTotal;
    final taxAmount = _taxable ? total * 0.16 : null;

    final result = QuoteLineItem(
      id: widget.item?.id,
      quoteId: widget.quoteId,
      laborId: _itemType == QuoteItemType.labor ? _selectedLabor?.id : null,
      description: _descController.text.trim(),
      itemType: _itemType,
      quantity: int.parse(_qtyController.text),
      unitPrice: double.parse(_unitPriceController.text),
      totalAmount: total,
      taxable: _taxable,
      taxAmount: taxAmount,
      unit: _unitController.text.trim().isEmpty
          ? null
          : _unitController.text.trim(),
      createdAt: widget.item?.createdAt ?? DateTime.now(),
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.crimsonRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart_rounded,
                          color: AppColors.crimsonRed,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isEditing ? 'Editar concepto' : 'Agregar concepto',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.warmGray,
                        ),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Tipo de concepto
                  const Text(
                    'Tipo de concepto',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warmGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _adminItemTypes.map((type) {
                      final selected = _itemType == type;
                      return ChoiceChip(
                        label: Text(type.label),
                        selected: selected,
                        selectedColor: AppColors.crimsonRed.withOpacity(0.12),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? AppColors.crimsonRed
                              : AppColors.warmGray,
                        ),
                        side: BorderSide(
                          color: selected
                              ? AppColors.crimsonRed
                              : const Color(0xFFE0D8D0),
                        ),
                        onSelected: (_) => setState(() => _itemType = type),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Labor picker (only if labor type)
                  if (_itemType == QuoteItemType.labor) ...[
                    DropdownButtonFormField<LaborCatalog>(
                      value: _selectedLabor,
                      decoration: const InputDecoration(
                        labelText: 'Mano de obra del catálogo *',
                        prefixIcon: Icon(Icons.build_outlined),
                      ),
                      hint: const Text('Selecciona del catálogo'),
                      items: _laborCatalog
                          .map(
                            (l) => DropdownMenuItem(
                              value: l,
                              child: Text(
                                '${l.name} — \$${l.basePrice.toStringAsFixed(2)}',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: _onLaborSelected,
                      validator: (v) =>
                          _itemType == QuoteItemType.labor && v == null
                          ? 'Selecciona una mano de obra'
                          : null,
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Descripción
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción *',
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Campo requerido' : null,
                  ),

                  const SizedBox(height: 14),

                  // Cantidad + Unidad + Precio
                  Row(
                    children: [
                      SizedBox(
                        width: 90,
                        child: TextFormField(
                          controller: _qtyController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Cant. *',
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Req.';
                            if ((int.tryParse(v) ?? 0) <= 0) {
                              return '> 0';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 90,
                        child: TextFormField(
                          controller: _unitController,
                          decoration: const InputDecoration(
                            labelText: 'Unidad',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _unitPriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Precio unitario *',
                            prefixText: '\$ ',
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Requerido';
                            }
                            if ((double.tryParse(v) ?? -1) < 0) {
                              return 'Inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // IVA toggle
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.warmGray, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.receipt_outlined,
                          color: AppColors.warmGray,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Aplica IVA (16%)',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.charcoal,
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: _taxable,
                          onChanged: (v) => setState(() => _taxable = v),
                          activeColor: AppColors.crimsonRed,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Total preview
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.charcoal.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total concepto',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.warmGray,
                          ),
                        ),
                        Text(
                          '\$ ${(_taxable ? _computedTotal * 1.16 : _computedTotal).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _submit,
                        child: Text(isEditing ? 'Guardar cambios' : 'Agregar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
