import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';
import 'package:sap_automotriz_app/features/users/domain/entities/user.dart';

class ServiceAssignmentSheet extends StatefulWidget {
  final Service service;
  final List<UserAccount> technicians;
  final void Function(List<UserAccount> assigned, int leadId) onConfirm;

  const ServiceAssignmentSheet({
    super.key,
    required this.service,
    required this.technicians,
    required this.onConfirm,
  });

  @override
  State<ServiceAssignmentSheet> createState() => _MultiAssignSheetState();
}

class _MultiAssignSheetState extends State<ServiceAssignmentSheet> {
  final Set<int> _selectedIds = {};
  int? _leadId;

  Color _loadColor(double hours) {
    if (hours == 0) return AppColors.warmGray;
    if (hours <= 4) return const Color(0xFF16A34A);
    if (hours <= 7) return AppColors.golden;
    return AppColors.crimsonRed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0D8D0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.golden.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.group_add_rounded,
                          color: AppColors.golden,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Asignar técnico(s)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.charcoal,
                              ),
                            ),
                            Text(
                              widget.service.folio,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.warmGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Selecciona uno o más técnicos:',
                    style: TextStyle(fontSize: 13, color: AppColors.warmGray),
                  ),
                  const SizedBox(height: 12),

                  ...widget.technicians.map((t) {
                    final hours = 10.0;
                    final color = _loadColor(hours);
                    final selected = true;
                    final isLead = false;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            // TODO: Agregar asignación de
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.golden.withOpacity(0.05)
                                : const Color(0xFFFAF6F2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selected
                                  ? AppColors.golden
                                  : const Color(0xFFEDE5DC),
                              width: selected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: color.withOpacity(0.12),
                                child: Text(
                                  (t.fullName)[0],
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  t.fullName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.charcoal,
                                  ),
                                ),
                              ),
                              Text(
                                '${hours}h hoy',
                                style: TextStyle(fontSize: 11, color: color),
                              ),
                              if (selected) ...[
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => setState(() => _leadId = t.id),
                                  child: Tooltip(
                                    message: 'Marcar como líder',
                                    child: Icon(
                                      isLead
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: isLead
                                          ? AppColors.golden
                                          : AppColors.warmGray,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  if (_selectedIds.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.golden.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppColors.golden,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _leadId != null
                                ? 'Líder: ${widget.technicians.firstWhere((t) => t.id == _leadId)}'
                                : 'Toca ★ para marcar al técnico líder',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.golden,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _selectedIds.isEmpty || _leadId == null
                          ? null
                          : () {
                              final assigned = widget.technicians
                                  .where(
                                    (t) => _selectedIds.contains(t.id as int),
                                  )
                                  .toList();
                              widget.onConfirm(assigned, _leadId!);
                            },
                      child: const Text('Confirmar y comenzar servicio'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
