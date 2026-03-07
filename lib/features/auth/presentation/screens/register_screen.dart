import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/shared/widgets/custom_elevated_button.dart';
import 'package:sap_automotriz_app/features/shared/widgets/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, RouteNames.dashboardAdmin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Volver al login'),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.crimsonRed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.directions_car_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'SAP Automotriz',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Crear cuenta',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Completa la información para registrarte',
                    style: TextStyle(fontSize: 14, color: AppColors.warmGray),
                  ),

                  const SizedBox(height: 32),

                  CustomTextFormField(
                    textEditingController: _nameController,
                    text: 'Nombre completo',
                    prefixIcon: Icon(Icons.badge_outlined),
                    validatorFunction: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu nombre';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  CustomTextFormField(
                    textEditingController: _emailController,
                    text: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email_outlined),
                    validatorFunction: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu correo';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  CustomTextFormField(
                    textEditingController: _phoneController,
                    keyboardType: TextInputType.phone,
                    text: 'Teléfono',
                    prefixIcon: Icon(Icons.phone_outlined),
                    validatorFunction: (v) =>
                        v == null || v.isEmpty ? 'Ingresa tu teléfono' : null,
                  ),

                  const SizedBox(height: 14),

                  CustomTextFormField(
                    textEditingController: _passwordController,
                    text: 'Contraseña',
                    obscureText: _obscurePassword,
                    validatorFunction: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Ingresa una contraseña';
                      }
                      if (v.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),

                  const SizedBox(height: 14),

                  CustomTextFormField(
                    textEditingController: _confirmController,
                    text: 'Confirmar contraseña',
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validatorFunction: (value) {
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  CustomElevatedButton(
                    text: 'Registrarme',
                    isLoading: _isLoading,
                    onPressed: _handleRegister,
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
