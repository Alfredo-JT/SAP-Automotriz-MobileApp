import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';

class AssignTechnicianSheet extends StatefulWidget {
  final Map<String, dynamic> service;
  final List<Map<String, dynamic>> technicians;
  final void Function(int technicianId, String technicianName) onAssign;

  const AssignTechnicianSheet({
    super.key,
    required this.service,
    required this.technicians,
    required this.onAssign,
  });

  @override
  State<AssignTechnicianSheet> createState() => _AssignTechnicianSheetState();
}

class _AssignTechnicianSheetState extends State<AssignTechnicianSheet> {
  int? _selectedId;

  Color _loadColor(double hours) {
    if (hours == 0) return AppColors.warmGray;
    if (hours <= 4) return const Color(0xFF16A34A);
    if (hours <= 7) return AppColors.golden;
    return AppColors.crimsonRed;
  }

  String _loadLabel(double hours) {
    if (hours == 0) return 'Disponible';
    if (hours <= 4) return 'Carga baja';
    if (hours <= 7) return 'Carga media';
    return 'Carga alta';
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
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
                // Title
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Asignar técnico',
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

                const SizedBox(height: 20),

                const Text(
                  'Selecciona un técnico según su carga actual:',
                  style: TextStyle(fontSize: 13, color: AppColors.warmGray),
                ),

                const SizedBox(height: 12),

                // Technician list
                ...widget.technicians.map((t) {
                  final hours = t['standardHoursToday'] as double;
                  final color = _loadColor(hours);
                  final selected = _selectedId == t['id'];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedId = t['id'] as int),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.crimsonRed.withOpacity(0.05)
                              : const Color(0xFFFAF6F2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected
                                ? AppColors.crimsonRed
                                : const Color(0xFFEDE5DC),
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: color.withOpacity(0.12),
                              child: Text(
                                (t['name'] as String)[0],
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.charcoal,
                                    ),
                                  ),
                                  Text(
                                    '${t['activeServices']} servicio${(t['activeServices'] as int) != 1 ? 's' : ''} activo${(t['activeServices'] as int) != 1 ? 's' : ''}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.warmGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _loadLabel(hours),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: color,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${hours}h hoy',
                                  style: TextStyle(fontSize: 11, color: color),
                                ),
                              ],
                            ),
                            if (selected) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.crimsonRed,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _selectedId == null
                        ? null
                        : () {
                            final tech = widget.technicians.firstWhere(
                              (t) => t['id'] == _selectedId,
                            );
                            widget.onAssign(
                              _selectedId!,
                              tech['name'] as String,
                            );
                          },
                    child: const Text('Confirmar asignación'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
