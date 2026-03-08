import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/customers/domain/entities/customer.dart';
import 'package:sap_automotriz_app/features/shared/widgets/custom_text_form_field.dart';

class CustomerFormDialog extends StatefulWidget {
  final Customer? customer;
  const CustomerFormDialog({super.key, this.customer});

  @override
  State<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends State<CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _rfcController;

  bool get isEditing => widget.customer != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.customer?.fullName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.customer?.phone ?? '',
    );
    _emailController = TextEditingController(
      text: widget.customer?.email ?? '',
    );
    _rfcController = TextEditingController(text: widget.customer?.rfc ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _rfcController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final result = Customer(
      id: widget.customer?.id,
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      rfc: _rfcController.text.trim().isEmpty
          ? null
          : _rfcController.text.trim(),
      createdAt: widget.customer?.createdAt ?? DateTime.now(),
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
                        Icons.person_add_rounded,
                        color: AppColors.crimsonRed,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEditing ? 'Editar cliente' : 'Nuevo cliente',
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

                CustomTextFormField(
                  controller: _nameController,
                  text: 'Nombre completo',
                  prefixIcon: Icon(Icons.badge_outlined),
                  validatorFunction: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),

                const SizedBox(height: 14),

                CustomTextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  text: 'Teléfono',
                  prefixIcon: Icon(Icons.phone_outlined),
                  validatorFunction: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),

                const SizedBox(height: 14),

                CustomTextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  text: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email_outlined),
                  validatorFunction: (v) =>
                      v == null || v.isEmpty ? 'Campo requerido' : null,
                ),

                const SizedBox(height: 14),

                CustomTextFormField(
                  controller: _rfcController,
                  text: 'RFC',
                  prefixIcon: Icon(Icons.receipt_outlined),
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
                      child: Text(
                        isEditing ? 'Guardar cambios' : 'Crear cliente',
                      ),
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
