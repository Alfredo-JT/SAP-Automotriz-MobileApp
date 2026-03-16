import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/workshop_manager/shared/presentation/widgets/workshop_manager_layout.dart';
import '../widgets/service_card_wm.dart';

class WmAuthorizedScreen extends StatefulWidget {
  const WmAuthorizedScreen({super.key});

  @override
  State<WmAuthorizedScreen> createState() => _WmAuthorizedScreenState();
}

class _WmAuthorizedScreenState extends State<WmAuthorizedScreen> {
  final List<Map<String, dynamic>> _services = [
    {
      'id': 6,
      'folio': '060326-01',
      'shortDescription': 'Afinación mayor + cambio de bujías',
      'serviceType': 'maintenance',
      'channel': 'in_person',
      'intakeDate': '06/03/2026',
      'customerName': 'María Fernández',
      'carLabel': '2022 Kia Rio — MNO-987',
      'status': 'authorized',
      'assignedTechnicians': <String>[],
      'leadTechnician': null,
      'quoteTotal': 3200.00,
    },
  ];

  final List<Map<String, dynamic>> _technicians = [
    {
      'id': 2,
      'name': 'Luis Carrillo',
      'standardHoursToday': 3.5,
      'activeServices': 2,
    },
    {
      'id': 3,
      'name': 'Héctor Vega',
      'standardHoursToday': 1.0,
      'activeServices': 1,
    },
    {
      'id': 4,
      'name': 'Mario Soto',
      'standardHoursToday': 0.0,
      'activeServices': 0,
    },
  ];

  void _openAssignSheet(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MultiAssignSheet(
        service: service,
        technicians: _technicians,
        onConfirm: (assigned, leadId) {
          setState(() {
            final idx = _services.indexWhere((s) => s['id'] == service['id']);
            if (idx != -1) {
              _services[idx]['assignedTechnicians'] = assigned
                  .map((t) => t['name'] as String)
                  .toList();
              _services[idx]['leadTechnician'] = assigned.firstWhere(
                (t) => t['id'] == leadId,
                orElse: () => assigned.first,
              )['name'];
            }
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Técnicos asignados. Servicio iniciado.'),
              backgroundColor: Color(0xFF16A34A),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WorkshopManagerLayout(
      pageTitle: 'Aprobados por cliente',
      showBackButton: true,
      child: _services.isEmpty
          ? const Center(
              child: Text(
                'No hay servicios autorizados pendientes',
                style: TextStyle(color: AppColors.warmGray, fontSize: 14),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _services.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final s = _services[i];
                final assigned = s['assignedTechnicians'] as List<String>;
                return ServiceCardWm(
                  service: s,
                  primaryActionLabel: assigned.isEmpty
                      ? 'Asignar técnico(s)'
                      : 'Modificar asignación',
                  primaryActionIcon: Icons.group_add_rounded,
                  primaryActionColor: AppColors.golden,
                  onPrimaryAction: () => _openAssignSheet(s),
                  bottomInfo: assigned.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 13,
                                  color: AppColors.golden,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Líder: ${s['leadTechnician']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.golden,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            if (assigned.length > 1) ...[
                              const SizedBox(height: 3),
                              Text(
                                'Equipo: ${assigned.join(', ')}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.warmGray,
                                ),
                              ),
                            ],
                          ],
                        )
                      : null,
                );
              },
            ),
    );
  }
}

// ── Multi-assign bottom sheet ─────────────────────────────────────────────

class _MultiAssignSheet extends StatefulWidget {
  final Map<String, dynamic> service;
  final List<Map<String, dynamic>> technicians;
  final void Function(List<Map<String, dynamic>> assigned, int leadId)
  onConfirm;

  const _MultiAssignSheet({
    required this.service,
    required this.technicians,
    required this.onConfirm,
  });

  @override
  State<_MultiAssignSheet> createState() => _MultiAssignSheetState();
}

class _MultiAssignSheetState extends State<_MultiAssignSheet> {
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
                              widget.service['folio'] as String,
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
                    final hours = t['standardHoursToday'] as double;
                    final color = _loadColor(hours);
                    final selected = _selectedIds.contains(t['id'] as int);
                    final isLead = _leadId == t['id'];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _selectedIds.remove(t['id'] as int);
                              if (_leadId == t['id']) _leadId = null;
                            } else {
                              _selectedIds.add(t['id'] as int);
                              if (_selectedIds.length == 1) {
                                _leadId = t['id'] as int;
                              }
                            }
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
                                  (t['name'] as String)[0],
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
                                  t['name'] as String,
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
                                  onTap: () =>
                                      setState(() => _leadId = t['id'] as int),
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
                                ? 'Líder: ${widget.technicians.firstWhere((t) => t['id'] == _leadId)['name']}'
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
                                    (t) =>
                                        _selectedIds.contains(t['id'] as int),
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
