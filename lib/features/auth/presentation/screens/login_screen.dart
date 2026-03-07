import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/shared/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
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
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.charcoal,
      body: Row(
        children: [
          // Left panel — branding
          if (isDesktop)
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(color: AppColors.charcoal),
                child: Stack(
                  children: [
                    // Decorative background circles
                    Positioned(
                      top: -80,
                      left: -80,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.crimsonRed.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -60,
                      right: -60,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.golden.withOpacity(0.06),
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(56),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.crimsonRed,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.directions_car_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SAP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                  Text(
                                    'AUTOMOTRIZ',
                                    style: TextStyle(
                                      color: AppColors.warmGray,
                                      fontSize: 10,
                                      letterSpacing: 2.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const Spacer(),

                          // Tagline
                          Container(
                            padding: const EdgeInsets.only(left: 16),
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: AppColors.crimsonRed,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sistema de\nGestión',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                    height: 1.15,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Control total de servicios,\nclientes y operaciones del taller.',
                                  style: TextStyle(
                                    color: AppColors.warmGray,
                                    fontSize: 15,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // Bottom stats
                          Row(
                            children: [
                              _StatChip(
                                icon: Icons.build_rounded,
                                label: 'Servicios',
                              ),
                              const SizedBox(width: 12),
                              _StatChip(
                                icon: Icons.people_rounded,
                                label: 'Clientes',
                              ),
                              const SizedBox(width: 12),
                              _StatChip(
                                icon: Icons.receipt_long_rounded,
                                label: 'Cotizaciones',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Right panel — form
          Expanded(
            flex: isDesktop ? 4 : 10,
            child: Container(
              color: AppColors.creamWhite,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isDesktop) ...[
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.crimsonRed,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.directions_car_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
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
                            const SizedBox(height: 32),
                          ],

                          const Text(
                            'Bienvenido',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.charcoal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Ingresa tus credenciales para continuar',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.warmGray,
                            ),
                          ),

                          const SizedBox(height: 36),

                          // CustomTextFormField Email
                          CustomTextFormField(
                            textEditingController: _emailController,
                            text: 'Correo electrónico',
                            prefixIcon: const Icon(Icons.email_outlined),
                            validatorFunction: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Ingresa tu correo';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // CustomTextFormField Password
                          CustomTextFormField(
                            obscureText: true,
                            textEditingController: _passwordController,
                            text: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            validatorFunction: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Ingresa tu contraseña';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('¿Olvidaste tu contraseña?'),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Login button
                          CustomElevatedButton(
                            isLoading: _isLoading,
                            text: 'Iniciar sesión',
                            onPressed: _handleLogin,
                          ),
                          const SizedBox(height: 24),

                          // Divider
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(color: Color(0xFFE0D8D0)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  '¿No tienes cuenta?',
                                  style: TextStyle(
                                    color: AppColors.warmGray,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(color: Color(0xFFE0D8D0)),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          CustomOutlinedButton(
                            text: 'Crear cuenta',
                            onPressed: () => Navigator.pushNamed(
                              context,
                              RouteNames.register,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.golden, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: AppColors.warmGray, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
