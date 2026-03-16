import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/admin/service_labor/domain/entities/labor_catalog.dart';

class LaborCatalogFormDialog extends StatefulWidget {
  final LaborCatalog? labor;
  const LaborCatalogFormDialog({super.key, this.labor});

  @override
  State<LaborCatalogFormDialog> createState() => _LaborCatalogFormDialogState();
}

class _LaborCatalogFormDialogState extends State<LaborCatalogFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _hoursController;
  late final TextEditingController _priceController;

  bool get isEditing => widget.labor != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.labor?.name ?? '');
    _hoursController = TextEditingController(
      text: widget.labor?.standardHours.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: widget.labor?.basePrice.toStringAsFixed(2) ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hoursController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final result = LaborCatalog(
      id: widget.labor?.id,
      name: _nameController.text.trim(),
      standardHours: double.parse(_hoursController.text),
      basePrice: double.parse(_priceController.text),
      createdAt: widget.labor?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
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
                        Icons.build_circle_outlined,
                        color: AppColors.crimsonRed,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEditing ? 'Editar mano de obra' : 'Nueva mano de obra',
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

                const SizedBox(height: 24),

                // Nombre
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del servicio *',
                    prefixIcon: Icon(Icons.label_outline_rounded),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    // Horas estándar
                    Expanded(
                      child: TextFormField(
                        controller: _hoursController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Horas estándar *',
                          prefixIcon: Icon(Icons.schedule_outlined),
                          suffixText: 'hrs',
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Requerido';
                          final h = double.tryParse(v);
                          if (h == null || h <= 0) {
                            return 'Debe ser > 0';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Precio base
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Precio base *',
                          prefixIcon: Icon(Icons.attach_money_rounded),
                          prefixText: '\$ ',
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Requerido';
                          final p = double.tryParse(v);
                          if (p == null || p < 0) {
                            return 'Precio inválido';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

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
                      child: Text(isEditing ? 'Guardar cambios' : 'Crear'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
