import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/dashboard/presentation/widgets/widgets.dart';
import 'package:sap_automotriz_app/features/service_labor/domain/entities/labor_catalog.dart';
import 'package:sap_automotriz_app/features/service_labor/presentation/widgets/widgets.dart';

class LaborCatalogDetailScreen extends StatefulWidget {
  final LaborCatalog labor;
  const LaborCatalogDetailScreen({super.key, required this.labor});

  @override
  State<LaborCatalogDetailScreen> createState() =>
      _LaborCatalogDetailScreenState();
}

class _LaborCatalogDetailScreenState extends State<LaborCatalogDetailScreen> {
  late LaborCatalog _labor;

  @override
  void initState() {
    super.initState();
    _labor = widget.labor;
  }

  void _edit() async {
    final result = await showDialog<LaborCatalog>(
      context: context,
      builder: (_) => LaborCatalogFormDialog(labor: _labor),
    );
    if (result != null) setState(() => _labor = result);
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      currentRoute: RouteNames.laborCatalog,
      pageTitle: 'Detalle de mano de obra',
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
          // Main info card
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
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.crimsonRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.build_circle_rounded,
                    color: AppColors.crimsonRed,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _labor.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 32,
                        runSpacing: 12,
                        children: [
                          _DetailItem(
                            icon: Icons.schedule_outlined,
                            label: 'Horas estándar',
                            value: '${_labor.standardHours} hrs',
                          ),
                          _DetailItem(
                            icon: Icons.attach_money_rounded,
                            label: 'Precio base',
                            value: '\$ ${_labor.basePrice.toStringAsFixed(2)}',
                            valueColor: AppColors.charcoal,
                            valueBold: true,
                          ),
                          _DetailItem(
                            icon: Icons.calendar_today_outlined,
                            label: 'Creado',
                            value: _formatDate(_labor.createdAt),
                          ),
                          _DetailItem(
                            icon: Icons.update_rounded,
                            label: 'Actualizado',
                            value: _formatDate(_labor.updatedAt),
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

          // Derived stats card
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
                  'Información derivada',
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
                        label: 'Costo por hora',
                        value: _labor.standardHours > 0
                            ? '\$ ${(_labor.basePrice / _labor.standardHours).toStringAsFixed(2)}'
                            : '—',
                        icon: Icons.monetization_on_outlined,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _StatCard(
                        label: 'Precio con IVA (16%)',
                        value:
                            '\$ ${(_labor.basePrice * 1.16).toStringAsFixed(2)}',
                        icon: Icons.receipt_outlined,
                        color: AppColors.golden,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _StatCard(
                        label: 'Duración estimada',
                        value: _labor.standardHours >= 1
                            ? '${_labor.standardHours.toStringAsFixed(1)} hrs'
                            : '${(_labor.standardHours * 60).toStringAsFixed(0)} min',
                        icon: Icons.timer_outlined,
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
  final Color? valueColor;
  final bool valueBold;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: valueBold ? FontWeight.w700 : FontWeight.w500,
                color: valueColor ?? AppColors.charcoal,
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
