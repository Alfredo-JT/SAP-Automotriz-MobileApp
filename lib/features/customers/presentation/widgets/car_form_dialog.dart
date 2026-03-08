import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/car.dart';
import 'package:sap_automotriz_app/features/shared/widgets/custom_text_form_field.dart';

class CarFormDialog extends StatefulWidget {
  final Car? car;
  final int customerId;
  const CarFormDialog({super.key, this.car, required this.customerId});

  @override
  State<CarFormDialog> createState() => _CarFormDialogState();
}

class _CarFormDialogState extends State<CarFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _makeController;
  late final TextEditingController _modelController;
  late final TextEditingController _yearController;
  late final TextEditingController _colorController;
  late final TextEditingController _plateController;

  bool get isEditing => widget.car != null;

  @override
  void initState() {
    super.initState();
    _makeController = TextEditingController(text: widget.car?.make ?? '');
    _modelController = TextEditingController(text: widget.car?.model ?? '');
    _yearController = TextEditingController(
      text: widget.car?.year.toString() ?? '',
    );
    _colorController = TextEditingController(text: widget.car?.color ?? '');
    _plateController = TextEditingController(
      text: widget.car?.licensePlate ?? '',
    );
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final result = Car(
      id: widget.car?.id,
      customerId: widget.customerId,
      make: _makeController.text.trim(),
      model: _modelController.text.trim(),
      year: int.tryParse(_yearController.text) ?? DateTime.now().year,
      color: _colorController.text.trim(),
      licensePlate: _plateController.text.trim().toUpperCase(),
      createdAt: widget.car?.createdAt ?? DateTime.now(),
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        Icons.directions_car_rounded,
                        color: AppColors.crimsonRed,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEditing ? 'Editar vehículo' : 'Agregar vehículo',
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

                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _makeController,
                        text: 'Marca',
                        prefixIcon: Icon(Icons.branding_watermark_outlined),
                        validatorFunction: (v) =>
                            v == null || v.isEmpty ? 'Requerido' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _modelController,
                        text: 'Modelo',
                        prefixIcon: Icon(Icons.directions_car_outlined),
                        validatorFunction: (v) =>
                            v == null || v.isEmpty ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        text: 'Año',
                        validatorFunction: (v) {
                          if (v == null || v.isEmpty) return 'Requerido';
                          final y = int.tryParse(v);
                          if (y == null || y < 1900 || y > 2100) {
                            return 'Año inválido';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextFormField(
                        controller: _colorController,
                        text: 'Color',
                        prefixIcon: Icon(Icons.color_lens_outlined),
                        validatorFunction: (v) =>
                            v == null || v.isEmpty ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                CustomTextFormField(
                  controller: _plateController,
                  text: 'Placas',
                  prefixIcon: Icon(Icons.pin_outlined),
                  validatorFunction: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
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
                      child: Text(isEditing ? 'Guardar cambios' : 'Agregar'),
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
