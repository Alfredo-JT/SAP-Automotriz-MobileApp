import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/services/domain/entities/entities.dart';

// ── Status badge ───────────────────────────────────────────────────────────
Color serviceStatusColor(ServiceStatus s) {
  switch (s) {
    case ServiceStatus.notStarted:
      return AppColors.warmGray;
    case ServiceStatus.underReview:
      return const Color(0xFF7C3AED);
    case ServiceStatus.quoted:
      return const Color(0xFF2563EB);
    case ServiceStatus.authorized:
      return AppColors.golden;
    case ServiceStatus.inProgress:
      return const Color(0xFFEA580C);
    case ServiceStatus.completed:
      return const Color(0xFF16A34A);
    case ServiceStatus.delivered:
      return const Color(0xFF0D9488);
    case ServiceStatus.cancelled:
      return AppColors.crimsonRed;
    case ServiceStatus.notAuthorized:
      return AppColors.warmGray;
  }
}

class ServiceStatusBadge extends StatelessWidget {
  final ServiceStatus status;
  const ServiceStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = serviceStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ── Channel icon ──────────────────────────────────────────────────────────
IconData channelIcon(ServiceChannel c) {
  switch (c) {
    case ServiceChannel.inPerson:
      return Icons.store_rounded;
    case ServiceChannel.phoneCall:
      return Icons.phone_rounded;
    case ServiceChannel.whatsapp:
      return Icons.chat_bubble_rounded;
  }
}

// ── Date helpers ──────────────────────────────────────────────────────────
String formatDate(DateTime? dt) {
  if (dt == null) return '—';
  return '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';
}
