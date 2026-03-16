import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/workshop_manager/shared/presentation/widgets/workshop_manager_layout.dart';

class WorkloadScreen extends StatelessWidget {
  const WorkloadScreen({super.key});

  static const List<Map<String, dynamic>> _technicians = [
    {
      'id': 2,
      'name': 'Luis Carrillo',
      'standardHoursToday': 3.5,
      'standardHoursWeek': 18.0,
      'activeServices': 2,
      'services': [
        {'folio': '100326-01', 'description': 'Cambio de aceite', 'hours': 0.5},
        {
          'folio': '090326-03',
          'description': 'Revisión suspensión',
          'hours': 3.0,
        },
      ],
    },
    {
      'id': 3,
      'name': 'Héctor Vega',
      'standardHoursToday': 1.0,
      'standardHoursWeek': 9.0,
      'activeServices': 1,
      'services': [
        {
          'folio': '080326-02',
          'description': 'Balanceo y alineación',
          'hours': 1.0,
        },
      ],
    },
    {
      'id': 4,
      'name': 'Mario Soto',
      'standardHoursToday': 0.0,
      'standardHoursWeek': 4.5,
      'activeServices': 0,
      'services': [],
    },
  ];

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
    return WorkshopManagerLayout(
      pageTitle: 'Carga de trabajo',
      showBackButton: true,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _technicians.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final t = _technicians[i];
          final hoursToday = t['standardHoursToday'] as double;
          final hoursWeek = t['standardHoursWeek'] as double;
          final color = _loadColor(hoursToday);
          final services = t['services'] as List<Map<String, dynamic>>;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEDE5DC)),
            ),
            child: Column(
              children: [
                // Technician header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: color.withOpacity(0.12),
                        child: Text(
                          (t['name'] as String)[0],
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
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
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.charcoal,
                              ),
                            ),
                            const SizedBox(height: 2),
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
                                _loadLabel(hoursToday),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${hoursToday}h hoy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: color,
                            ),
                          ),
                          Text(
                            '${hoursWeek}h semana',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.warmGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ocupación del día (máx. 8h)',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.warmGray,
                            ),
                          ),
                          Text(
                            '${(hoursToday / 8 * 100).clamp(0, 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (hoursToday / 8).clamp(0.0, 1.0),
                          backgroundColor: const Color(0xFFEDE5DC),
                          color: color,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Service list
                if (services.isEmpty)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      'Sin servicios asignados',
                      style: TextStyle(fontSize: 12, color: AppColors.warmGray),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        const Divider(height: 1, color: Color(0xFFEDE5DC)),
                        const SizedBox(height: 10),
                        ...services.map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  s['folio'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.charcoal,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    s['description'] as String,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.warmGray,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${s['hours']}h',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
