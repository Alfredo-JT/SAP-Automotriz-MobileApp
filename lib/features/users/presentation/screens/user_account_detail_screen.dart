import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/dashboard/presentation/widgets/widgets.dart';
import 'package:sap_automotriz_app/features/users/domain/entities/user.dart';
import '../widgets/user_account_form_dialog.dart';

class UserAccountDetailScreen extends StatefulWidget {
  final UserAccount user;
  const UserAccountDetailScreen({super.key, required this.user});

  @override
  State<UserAccountDetailScreen> createState() =>
      _UserAccountDetailScreenState();
}

class _UserAccountDetailScreenState extends State<UserAccountDetailScreen> {
  late UserAccount _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  void _edit() async {
    final result = await showDialog<UserAccount>(
      context: context,
      builder: (_) => UserAccountFormDialog(user: _user),
    );
    if (result != null) setState(() => _user = result);
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  Color get _roleColor {
    switch (_user.role) {
      case UserRole.admin:
        return AppColors.crimsonRed;
      case UserRole.technician:
        return const Color(0xFF2563EB);
      case UserRole.workshopManager:
        return AppColors.golden;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentRoute: RouteNames.userAccounts,
      pageTitle: 'Detalle de usuario',
      actions: [
        OutlinedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, size: 16),
          label: const Text('Volver'),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: _edit,
          icon: const Icon(Icons.edit_rounded, size: 16),
          label: const Text('Editar'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEDE5DC)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: _roleColor.withOpacity(0.12),
                      child: Text(
                        _user.fullName[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: _roleColor,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _user.isActive
                              ? const Color(0xFF16A34A)
                              : AppColors.warmGray,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 22),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _user.fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.charcoal,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _roleColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _user.role.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _roleColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (_user.isActive
                                          ? const Color(0xFF16A34A)
                                          : AppColors.warmGray)
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _user.isActive ? 'Activo' : 'Inactivo',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _user.isActive
                                    ? const Color(0xFF16A34A)
                                    : AppColors.warmGray,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 28,
                        runSpacing: 10,
                        children: [
                          _DetailItem(
                            icon: Icons.phone_outlined,
                            label: 'Teléfono',
                            value: _user.phone,
                          ),
                          _DetailItem(
                            icon: Icons.email_outlined,
                            label: 'Correo',
                            value: _user.email ?? '—',
                          ),
                          _DetailItem(
                            icon: Icons.calendar_today_outlined,
                            label: 'Alta',
                            value: _formatDate(_user.createdAt),
                          ),
                          _DetailItem(
                            icon: Icons.update_rounded,
                            label: 'Actualizado',
                            value: _formatDate(_user.updatedAt),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Salary card — only if has salary
          if (_user.salary != null)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEDE5DC)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información salarial',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Salario mensual',
                          value: '\$ ${_user.salary!.toStringAsFixed(2)}',
                          icon: Icons.payments_outlined,
                          color: AppColors.crimsonRed,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _StatCard(
                          label: 'Salario semanal (est.)',
                          value: '\$ ${(_user.salary! / 4).toStringAsFixed(2)}',
                          icon: Icons.calendar_view_week_outlined,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _StatCard(
                          label: 'Salario diario (est.)',
                          value:
                              '\$ ${(_user.salary! / 30).toStringAsFixed(2)}',
                          icon: Icons.today_outlined,
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.warmGray),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.warmGray),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.charcoal,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: AppColors.warmGray),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
